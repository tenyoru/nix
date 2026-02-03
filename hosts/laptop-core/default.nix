{ path, mylib, ... }: let
  dirModules = mylib.scanPaths path;
  hostModules = import ./host.nix { inherit mylib; };
  homeModules = import ./home.nix { inherit mylib; };

in {
  username = "Tenyoru";
  name = "core";
  platform = "x86_64-linux";

  dotfiles = {
    # Modules that use dotfile config instead of nix config
    modules = [ "neovim" "tmux" "fish" ];

    # Direct symlinks (configs without main module)
    configs = [ "btop" "ghostty" "mpv" "niri" "qutebrowser" ];

    # Add dotfiles/bin to PATH
    bin = true;
  };

  modules = {
    host = dirModules ++ hostModules.imports;
    home = homeModules.imports;
  };
}
