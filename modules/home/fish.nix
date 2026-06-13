{config, mylib, pkgs, ...}: {
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "puffer-fish";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "gruvbox";
        src = pkgs.fishPlugins.gruvbox.src;
      }
    ];

    shellAliases = {
      vim = "nvim";
      v = "nvim";
      flake = "nix develop -C $SHELL";
      ll = "ls -la";
      la = "ls -A";
      ".." = "cd ..";
      "..." = "cd ../..";
      search = "cha ddg:";
    };

    interactiveShellInit = ''
      set -g fish_greeting
      fish_vi_key_bindings
      bind -M default yy fish_clipboard_copy
      bind -M default Y fish_clipboard_copy
      bind -M default p fish_clipboard_paste
      bind -M visual y fish_clipboard_copy
      theme_gruvbox dark hard
    '';

    shellInit = ''
      if test -f /etc/profiles/per-user/${config.home.username}/etc/profile.d/hm-session-vars.fish
        set -e __HM_SESS_VARS_SOURCED
        source /etc/profiles/per-user/${config.home.username}/etc/profile.d/hm-session-vars.fish
      end

      if not set -q NIXOS_CONFIG_PATH
        set -gx NIXOS_CONFIG_PATH ${mylib.nixosConfigPath}
      end

      set -gx EDITOR nvim
      set -gx VISUAL nvim
      set -gx NIX_BUILD_SHELL ${pkgs.fish}/bin/fish
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
      set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
      set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
      fish_add_path $HOME/.local/bin
      set -gx CLAUDE_AUTOCOMPACT_PCT_OVERRIDE 80
      if test -f /run/secrets/context7_api_key
        set -gx CONTEXT7_API_KEY (cat /run/secrets/context7_api_key)
      end
    '';
  };

  home.packages = with pkgs; [
    fzf
    fd
    bat
  ];
}
