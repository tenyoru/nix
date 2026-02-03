{self, nixpkgs, ...} @ inputs: let
  inherit (inputs.nixpkgs) lib;

  mylib = import ./lib {inherit lib self;};

  getHosts = let
    entries = builtins.readDir "${self}/hosts";
    entryNames = builtins.attrNames entries;
  in
    builtins.filter (name: entries.${name} == "directory") entryNames;

  hostConfigs = builtins.listToAttrs (map (name: let
    path = "${self}/hosts/${name}";
    mods = mylib.getModulePath;
  in {
    name = name;
    value = import ("${self}/hosts/${name}/default.nix") {
      inherit
        path
        mods
        mylib
        ;
    };
  }) getHosts);

  nixosConfigs = builtins.listToAttrs (map (name: let
    host = hostConfigs.${name};
    hostModules = host.modules.host or [];
    hostConfig = mylib.mergeConfig host;

    homeModules = host.modules.home or [];
    system = hostConfig.platform;

    extraModules = [
      # Here you can add base modules that should always be included
      "${self}/modules/base.nix"
    ] ++ (if builtins.hasAttr "home" host.modules then [ "${self}/home" ] else []);
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

      modules = with inputs; [
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        {
          home-manager.sharedModules = homeModules;
        }
      ] ++ hostModules ++ extraModules;
    };
  }) getHosts);

  forAllSystems = func:
    let
      allSystemNames = builtins.attrValues (builtins.mapAttrs (_: host: host.platform) hostConfigs);
    in nixpkgs.lib.genAttrs allSystemNames func;
in {
  nixosConfigurations = nixosConfigs;

  devShells = (
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
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    }
  );

  formatter = forAllSystems (
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}
