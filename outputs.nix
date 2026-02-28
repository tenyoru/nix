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
      mods = mylib.getModulePath;
    in {
      name = name;
      value = import "${self}/devices/${name}/default.nix" {
        inherit
          path
          mods
          mylib
          ;
      };
    })
    getHosts);

  nixosConfigs = builtins.listToAttrs (
    builtins.filter (x: x != null) (map (name: let
        host = hostConfigs.${name};
        isNixOnDroid = (host.type or "") == "nix-on-droid";
      in
        if isNixOnDroid
        then null
        else let
          hostModules = host.modules.host or [];
          hostConfig = mylib.mergeConfig host;

          homeModules = host.modules.home or [];
          system = hostConfig.platform;

          extraModules =
            [
              # Here you can add base modules that should always be included
              "${self}/modules/base.nix"
            ]
            ++ (
              if builtins.hasAttr "home" host.modules
              then ["${self}/home"]
              else []
            );
        in {
          name = host.name or name;

          value = lib.nixosSystem {
            specialArgs = {
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

            modules = with inputs;
              [
                home-manager.nixosModules.home-manager
                disko.nixosModules.disko
                sops-nix.nixosModules.sops
                {
                  home-manager.sharedModules = homeModules;
                }
              ]
              ++ hostModules ++ extraModules;
          };
        })
      getHosts)
  );

  nixOnDroidConfigs = builtins.listToAttrs (
    builtins.filter (x: x != null) (map (name: let
        host = hostConfigs.${name};
        isNixOnDroid = (host.type or "") == "nix-on-droid";
      in
        if !isNixOnDroid
        then null
        else let
          hostConfig = mylib.mergeConfig host;
          homeModules = host.modules.home or [];
          nixOnDroidModules = host.modules.nix-on-droid or [];
          system = hostConfig.platform;
        in {
          name = host.name or name;

          value = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            modules =
              nixOnDroidModules
              ++ [
                {
                  home-manager = {
                    config = lib.mkMerge homeModules;
                    backupFileExtension = "hm-bak";
                    useGlobalPkgs = true;
                  };
                }
              ];

            extraSpecialArgs = {
              inherit
                inputs
                self
                hostConfig
                mylib
                lib
                ;
            };
          };
        })
      getHosts)
  );

  forAllSystems = func: let
    allSystemNames = builtins.attrValues (builtins.mapAttrs (_: host: host.platform) hostConfigs);
  in
    nixpkgs.lib.genAttrs allSystemNames func;
in {
  nixosConfigurations = nixosConfigs;
  nixOnDroidConfigurations = nixOnDroidConfigs;

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
