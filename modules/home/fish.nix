{ pkgs, config, lib, mylib, hostConfig, ... }:
let
  useConfig = builtins.elem "fish" (hostConfig.dotfiles.modules or []);
  configPath = "${mylib.dotfilesDir}/config/fish/config.fish";
in {
  programs.fish = {
    enable = true;

    # Plugins always managed by nix
    plugins = [
      { name = "puffer-fish"; src = pkgs.fishPlugins.puffer.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "gruvbox"; src = pkgs.fishPlugins.gruvbox.src; }
    ];

    interactiveShellInit =
      if useConfig then ''
        # Source config from dotfiles
        if test -f ${configPath}
          source ${configPath}
        end
      '' else ''
        set fish_greeting
        set -g fish_greeting
        fish_vi_key_bindings
        bind yy fish_clipboard_copy
        bind Y fish_clipboard_copy
        bind p fish_clipboard_paste
        theme_gruvbox dark hard
      '';
  };

  # Dependencies
  home.packages = with pkgs; [
    fzf
    fd
    bat
  ];
}

# run `tide configure` to set up tide theme
