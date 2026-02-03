{ self, lib, ... }:let

  defaultArgs = import "${self}/lib/defaultArgs.nix";

  # Flake directory (hardcoded for pure evaluation)
  flakeDir = "/home/${defaultArgs.username}/.nixos";

  # Dotfiles directory
  dotfilesDir = "${flakeDir}/dotfiles";

  # Get full path to dotfile
  # Usage: config.lib.file.mkOutOfStoreSymlink (mylib.dotfile ".config/nvim")
  dotfile = path: "${dotfilesDir}/${path}";

  # Default configs directory in nixos repo
  defaultsDir = "${self}/defaults";

  # Create dotfile with default fallback
  # Usage: mylib.mkDotfile { config, name, target?, default? }
  # - name: config name (e.g. "nvim")
  # - target: path in dotfiles (default: ".config/${name}")
  # - default: path to default config (default: defaults/${name})
  mkDotfile = { config, name, target ? ".config/${name}", default ? "${defaultsDir}/${name}" }: {
    home.file.${target}.source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${target}";

    home.activation."dotfile-${name}" =
      config.lib.dag.entryAfter ["writeBoundary"] ''
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

  findPath = base: name:
    let
      paths = [
        "${base}/${name}.nix"
        "${base}/${name}"
      ];
      existing = builtins.filter builtins.pathExists paths;
    in
      if existing != [] then builtins.head existing
      else throw "${builtins.head paths} does not exist.";

  findPaths = base: names: map (name: findPath base name) names;

  scanPaths = path:
    let
      entries = builtins.readDir path;
      entryNames = builtins.attrNames entries;

       filtered = builtins.filter (name:
           # Include directories
           (entries.${name} == "directory") ||

           # Include regular .nix files, but exclude entry points
           (entries.${name} == "regular" &&
            name != "default.nix" &&
            name != "home.nix" &&
            name != "host.nix"
            #lib.strings.hasSuffix ".nix" name
           )) entryNames;

    in
      map (name: path + "/" + name) filtered;

  getModulePath = "${self}/modules";

  getModules = base: entries:
    builtins.concatLists (map (entry:
      if builtins.isString entry then
        [ (findPath base entry) ]
      else if builtins.isAttrs entry && entry ? name then
        let
          path = findPath base entry.name;
        in
          if entry ? config then
            [
              path
              { _module.args.${entry.name} = entry.config; }
            ]
          else
            [ path ]
      else if builtins.isPath entry || builtins.isFunction entry || builtins.isAttrs entry then
        [ entry ]
      else
        throw "Invalid module entry: expected string, module, or { name, config? }"
    ) entries);

  getHomeModules = entries: getModules (getModulePath + "/home") entries;
  getHostModules = entries: getModules (getModulePath + "/host") entries;

  getDirModules = path:
    let
      hardwarePath = path + "/hardware.nix";

      allFiles = scanPaths path;

      filteredFiles = builtins.filter (file: file != hardwarePath) allFiles;

      hardwareModule = if builtins.elem hardwarePath allFiles then [ import hardwarePath ] else [];

    in
      filteredFiles ++ hardwareModule;

in {
  findPath = findPath;
  getHomeModules = getHomeModules;
  getHostModules = getHostModules;
  getDirModules = getDirModules;
  mergeConfig = mergeConfig;
  scanPaths = scanPaths;
  homeModuleDir = "${self}/modules/home";
  hostModuleDir = "${self}/modules/host";
  dotfile = dotfile;
  flakeDir = flakeDir;
  dotfilesDir = dotfilesDir;
  defaultsDir = defaultsDir;
  mkDotfile = mkDotfile;
}
