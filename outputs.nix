{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;

  mylib = import ./lib {inherit lib self;};
  getHosts = let
    entries = builtins.readDir "${self}/devices";
    entryNames = builtins.attrNames entries;
  in
    builtins.filter (name: entries.${name} == "directory") entryNames;

  hostConfigs = builtins.listToAttrs (map (name: let
      path = "${self}/devices/${name}";
      deviceTomlPath = "${path}/device.toml";
      defaultDeviceConfig = {
        name = name;
        dotfiles = {};
        host = {};
        home = {};
        packages = {};
        stablePackages = {};
        extraHostModules = [];
        extraHomeModules = [];
        extraNixosModules = [];
      };
      loadedDeviceConfig =
        if builtins.pathExists deviceTomlPath
        then mylib.readToml deviceTomlPath
        else {};
      deviceConfig =
        lib.recursiveUpdate defaultDeviceConfig loadedDeviceConfig;
    in {
      name = name;
      value = mylib.mkDevice {
        inherit path deviceConfig;
      };
    })
    getHosts);

  nixosConfigs = builtins.listToAttrs (map (name: let
      host = hostConfigs.${name};
      hostModules =
        (host.modules.host or [])
        ++ mylib.getHostModules (host.extraHostModules or []);
      secretsModulePath = "${self}/devices/${name}/secrets.nix";
      hostSecretsModule =
        if builtins.pathExists secretsModulePath
        then [secretsModulePath]
        else [];
      hostConfig = mylib.mergeConfig host;

      homeModules =
        (host.modules.home or [])
        ++ mylib.getHomeModules (host.extraHomeModules or []);
      extraNixosModules = host.extraNixosModules or [];
      system = hostConfig.platform;

      # Pi hosts opt in via device.toml's `raspberrypi = true`.
      # Their nixosSystem is a drop-in replacement for nixpkgs.lib.nixosSystem
      # that keeps its own pinned nixpkgs (required for the kernel/firmware
      # packages to evaluate). That pin is why home-manager (built against
      # our own newer unstable) can't be evaluated on Pi hosts — so they skip
      # home-manager entirely and use plain environment.systemPackages instead.
      isRaspberryPi = host.raspberrypi or false;
      nixosSystem =
        if isRaspberryPi
        then inputs.nixos-raspberrypi.lib.nixosSystem
        else lib.nixosSystem;

      extraModules =
        [
          # Here you can add base modules that should always be included
          "${self}/modules/base.nix"
        ]
        ++ (
          if builtins.hasAttr "home" host.modules && !isRaspberryPi
          then ["${self}/home"]
          else []
        );

      # Pi hosts skip home-manager (see hardware.nix — plain
      # environment.systemPackages instead) and disko (plain fileSystems
      # matching nixos-raspberrypi's own sd-image labels; deploy by flashing
      # their installer image once, then `nixos-rebuild switch --target-host`)
      baseModules =
        if isRaspberryPi
        then [inputs.sops-nix.nixosModules.sops]
        else [
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          {home-manager.sharedModules = homeModules;}
        ];
    in {
      name = host.name or name;

      value = nixosSystem ({
          # Pi hosts get `specialArgs = inputs // {extras}`, matching
          # nixos-raspberrypi's own README example verbatim (confirmed by an
          # isolated sanity-check flake) — a curated subset (what every other
          # host uses) triggered an infinite recursion in their firmware
          # overlay for reasons not fully root-caused, but reproducibly fixed
          # by passing the full `inputs` attrset instead.
          specialArgs =
            if isRaspberryPi
            then inputs // {inherit system hostConfig mylib homeModules;}
            else {
              inherit system;
              inherit
                inputs
                self
                hostConfig
                mylib
                lib
                homeModules
                ;
            };
        }
        // {
          modules =
            baseModules
            ++ hostModules
            ++ hostSecretsModule
            ++ extraModules
            ++ extraNixosModules;
        });
    })
    getHosts);

  forAllSystems = func: let
    allSystemNames = builtins.attrValues (builtins.mapAttrs (_: host: host.platform) hostConfigs);
  in
    nixpkgs.lib.genAttrs allSystemNames func;
in {
  nixosConfigurations = nixosConfigs;

  devShells = forAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
          bashInteractive

          clang
          # Nix-related
          alejandra
          deadnix
          statix
          # spell checker
          #typos
        ];
        name = "dots";
        shellHook = ''
          exec fish
        '';
      };
    }
  );

  formatter = forAllSystems (
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}
