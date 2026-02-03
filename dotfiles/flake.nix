{
  description = "Tenyoru's dotfiles";

  inputs = {};

  outputs = { self, ... }: rec {
    # Short alias
    homeModule = homeManagerModules.default;

    # Expose configs as an attribute set for easy access
    configs = {
      fish = ./config/fish;
      foot = ./config/foot;
      ghostty = ./config/ghostty;
      niri = ./config/niri;
      nvim = ./config/nvim;
      tmux = ./config/tmux;
      zathura = ./config/zathura;
      mpv = ./config/mpv;
      btop = ./config/btop;
      yazi = ./config/yazi;
      qutebrowser = ./config/qutebrowser;
      chawan = ./config/chawan;
    };

    # Home Manager module (symlinks only, deps handled by main modules)
    homeManagerModules.default = { config, lib, ... }: let
      cfg = config.dotfiles;
      enabledConfigs = lib.filterAttrs (_: v: v) cfg.configs;
      configNames = lib.attrNames enabledConfigs;
    in {
      options.dotfiles = {
        enable = lib.mkEnableOption "dotfiles management";

        path = lib.mkOption {
          type = lib.types.path;
          default = "${config.home.homeDirectory}/.nixos/dotfiles";
          description = "Path to dotfiles directory";
        };

        configs = lib.mkOption {
          type = lib.types.attrsOf lib.types.bool;
          default = {};
          description = "Configs to symlink (name = true to enable)";
        };

        bin = lib.mkEnableOption "add dotfiles/bin to PATH";
      };

      config = lib.mkIf cfg.enable (lib.mkMerge [
        {
          xdg.configFile = lib.mkMerge (map (name: {
            ${name}.source = config.lib.file.mkOutOfStoreSymlink "${cfg.path}/config/${name}";
          }) configNames);
        }

        (lib.mkIf cfg.bin {
          home.sessionPath = [ "${cfg.path}/bin" ];
        })
      ]);
    };
  };
}
