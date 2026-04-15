{
  self,
  lib,
  ...
}: let
  defaultArgs = import "${self}/lib/defaultArgs.nix";

  # Flake directory (hardcoded for pure evaluation)
  flakeDir = "/home/${defaultArgs.username}/.nixos";

  # Dotfiles directory
  dotfilesDir = "${flakeDir}/dotfiles";
  nixosConfigPath = flakeDir;
  scriptsDir = "${dotfilesDir}/scripts";
  scriptsBinDir = "${scriptsDir}/bin";
  scriptsPythonDir = "${scriptsDir}/python";

  # Get full path to dotfile
  # Usage: config.lib.file.mkOutOfStoreSymlink (mylib.dotfile ".config/nvim")
  dotfile = path: "${dotfilesDir}/${path}";

  # Check if dotfiles are enabled for this host
  # Usage: mylib.useDotfiles hostConfig
  useDotfiles = hostConfig: hostConfig.dotfiles.enable or false;

  # Get path to a config in dotfiles
  # Usage: mylib.dotfileConfig "tmux" -> "/home/user/.nixos/dotfiles/config/tmux"
  dotfileConfig = name: "${dotfilesDir}/config/${name}";

  # Default configs directory in nixos repo
  defaultsDir = "${self}/defaults";

  # Create dotfile with default fallback
  # Usage: mylib.mkDotfile { config, name, target?, default? }
  # - name: config name (e.g. "nvim")
  # - target: path in dotfiles (default: ".config/${name}")
  # - default: path to default config (default: defaults/${name})
  mkDotfile = {
    config,
    name,
    target ? ".config/${name}",
    default ? "${defaultsDir}/${name}",
  }: {
    home.file.${target}.source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${target}";

    home.activation."dotfile-${name}" = config.lib.dag.entryAfter ["writeBoundary"] ''
      if [ ! -e "${dotfilesDir}/${target}" ]; then
        mkdir -p "$(dirname "${dotfilesDir}/${target}")"
        if [ -e "${default}" ]; then
          cp -r "${default}" "${dotfilesDir}/${target}"
          echo "Copied default ${name} config to dotfiles"
        else
          mkdir -p "${dotfilesDir}/${target}"
          echo "Created empty ${name} config in dotfiles"
        fi
      fi
    '';
  };

  mergeConfig = config:
    builtins.removeAttrs
    (defaultArgs // config)
    defaultArgs.excludeKeys;

  findPath = base: name: let
    paths = [
      "${base}/${name}.nix"
      "${base}/${name}"
    ];
    existing = builtins.filter builtins.pathExists paths;
  in
    if existing != []
    then builtins.head existing
    else throw "${builtins.head paths} does not exist.";

  findPaths = base: names: map (name: findPath base name) names;

  readToml = path: builtins.fromTOML (builtins.readFile path);

  resolveEnabledModules = {
    defaultModules,
    configuredModules ? [],
    moduleFlags ? {},
  }: let
    baseModules =
      if configuredModules != []
      then configuredModules
      else defaultModules;
    enabledFromBase = builtins.filter (name: moduleFlags.${name} or true) baseModules;
    extraEnabled = builtins.filter (name: (moduleFlags.${name} or false) && !(builtins.elem name baseModules)) (builtins.attrNames moduleFlags);
  in
    enabledFromBase ++ extraEnabled;

  getDeviceModules = {
    deviceConfig,
    section,
    defaultModules,
  }: let
    modulesKey = "${section}Modules";
    configuredModules = deviceConfig.${modulesKey} or [];
    moduleFlags = deviceConfig.${section} or {};
  in
    resolveEnabledModules {
      inherit defaultModules configuredModules moduleFlags;
    };

  mkHomePackagesModule = {
    packageNames ? [],
    stablePackageNames ? [],
  }: {
    pkgs,
    inputs,
    lib,
    ...
  }: let
    toPath = name: lib.splitString "." name;
    resolvePkg = name: lib.attrByPath (toPath name) (throw "Package '${name}' not found in pkgs") pkgs;
    resolveStablePkg = name:
      lib.attrByPath
      (toPath name)
      (throw "Package '${name}' not found in stable pkgs")
      inputs.stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    home.packages =
      (map resolvePkg packageNames)
      ++ (map resolveStablePkg stablePackageNames);
  };

  mkDevice = {
    path,
    deviceConfig,
    defaultHostModules ? [],
    defaultHomeModules ? [],
    defaultPackages ? [],
    defaultStablePackages ? [],
  }: let
    hostModuleNames = getDeviceModules {
      inherit deviceConfig;
      section = "host";
      defaultModules = defaultHostModules;
    };
    homeModuleNames = getDeviceModules {
      inherit deviceConfig;
      section = "home";
      defaultModules = defaultHomeModules;
    };
    packageNames = getDeviceModules {
      inherit deviceConfig;
      section = "packages";
      defaultModules = defaultPackages;
    };
    stablePackageNames = getDeviceModules {
      inherit deviceConfig;
      section = "stablePackages";
      defaultModules = defaultStablePackages;
    };
  in
    deviceConfig
    // {
      modules = {
        host = importIfExists (path + "/hardware.nix") ++ getHostModules hostModuleNames;
        home =
          getHomeModules homeModuleNames
          ++ [
            (mkHomePackagesModule {
              inherit packageNames stablePackageNames;
            })
          ];
      };
    };

  importIfExists = path:
    if builtins.pathExists path
    then [path]
    else [];

  scanPaths = path: let
    entries = builtins.readDir path;
    entryNames = builtins.attrNames entries;

    filtered = builtins.filter (name:
      # Include directories
        (entries.${name} == "directory")
        ||
        # Include regular .nix files, but exclude entry points
        (
          entries.${name}
          == "regular"
          && name != "default.nix"
          && name != "home.nix"
          && name != "host.nix"
          #lib.strings.hasSuffix ".nix" name
        ))
    entryNames;
  in
    map (name: path + "/" + name) filtered;

  getModulePath = "${self}/modules";

  getModules = base: entries:
    builtins.concatLists (map (
        entry:
          if builtins.isString entry
          then [(findPath base entry)]
          else if builtins.isAttrs entry && entry ? name
          then let
            path = findPath base entry.name;
          in
            if entry ? config
            then [
              path
              {_module.args.${entry.name} = entry.config;}
            ]
            else [path]
          else if builtins.isPath entry || builtins.isFunction entry || builtins.isAttrs entry
          then [entry]
          else throw "Invalid module entry: expected string, module, or { name, config? }"
      )
      entries);

  getHomeModules = entries: getModules (getModulePath + "/home") entries;
  getHostModules = entries: getModules (getModulePath + "/host") entries;

  getDirModules = path: let
    hardwarePath = path + "/hardware.nix";

    allFiles = scanPaths path;

    filteredFiles = builtins.filter (file: file != hardwarePath) allFiles;

    hardwareModule =
      if builtins.elem hardwarePath allFiles
      then [import hardwarePath]
      else [];
  in
    filteredFiles ++ hardwareModule;

  scanNixPaths = path:
    builtins.filter (p: builtins.match ".*\\.nix$" (toString p) != null) (scanPaths path);
in {
  findPath = findPath;
  getHomeModules = getHomeModules;
  getHostModules = getHostModules;
  getDirModules = getDirModules;
  getDeviceModules = getDeviceModules;
  importIfExists = importIfExists;
  mergeConfig = mergeConfig;
  mkDevice = mkDevice;
  mkHomePackagesModule = mkHomePackagesModule;
  readToml = readToml;
  resolveEnabledModules = resolveEnabledModules;
  scanPaths = scanPaths;
  scanNixPaths = scanNixPaths;
  homeModuleDir = "${self}/modules/home";
  hostModuleDir = "${self}/modules/host";
  dotfile = dotfile;
  flakeDir = flakeDir;
  nixosConfigPath = nixosConfigPath;
  dotfilesDir = dotfilesDir;
  scriptsDir = scriptsDir;
  scriptsBinDir = scriptsBinDir;
  scriptsPythonDir = scriptsPythonDir;
  defaultsDir = defaultsDir;
  mkDotfile = mkDotfile;
  useDotfiles = useDotfiles;
  dotfileConfig = dotfileConfig;
}
