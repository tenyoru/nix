{
  self,
  pkgs,
  inputs,
  homeModules,
  hostConfig,
  mylib,
  lib,
  ...
}: let
  username = hostConfig.username;
  stateVersion = hostConfig.hmStateVersion;
  homeDirectory = "/home/${username}";

  # Convert dotfiles.configs list to attrset for dotfiles module
  dotfilesCfg = hostConfig.dotfiles or {};
  configsList = dotfilesCfg.configs or [];
  configsAttrs = builtins.listToAttrs (map (name: {
      inherit name;
      value = true;
    })
    configsList);
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs hostConfig mylib;
    };

    users.${username} = {
      imports =
        homeModules
        ++ [
          inputs.dotfiles.homeModule
          {
            dotfiles = {
              enable = configsList != [] || (dotfilesCfg.bin or false);
              bin = dotfilesCfg.bin or false;
              path = mylib.dotfilesDir;
              configs = configsAttrs;
            };
          }
        ];

      home = {
        inherit username;
        inherit stateVersion;
        inherit homeDirectory;

        sessionVariables = {
          NIXOS_CONFIG_PATH = mylib.nixosConfigPath;
          NIXOS_SCRIPTS_BIN_PATH = mylib.scriptsBinDir;
          NIXOS_SCRIPTS_PYTHON_PATH = mylib.scriptsPythonDir;
          CC = "zig cc";
          CXX = "zig c++";
        };
      };
    };
  };
}
