{ pkgs, config, lib, mylib, hostConfig, ... }:
let
  useConfig = mylib.useDotfiles hostConfig;
  configPath = mylib.dotfileConfig "tmux" + "/tmux.conf";
in {
  programs.tmux = {
    enable = true;

    # Plugins always managed by nix
    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
      fzf-tmux-url
      fuzzback
      resurrect
      sensible
      yank
      sessionist
    ];

    extraConfig =
      if useConfig then ''
        # Source config from dotfiles
        source-file ${configPath}
      '' else ''
        bind -n M-L split-window -h -c "#{pane_current_path}"
        bind -n M-K split-window -v -c "#{pane_current_path}"

        bind -T copy-mode-vi v send -X begin-selection
        bind P paste-buffer

        bind x kill-pane

        bind -r "<" swap-window -d -t -1
        bind -r ">" swap-window -d -t +1

        bind g display-popup -E "tmux has-session -t popup 2>/dev/null || tmux new-session -d -s popup -c '#{pane_current_path}'; tmux attach -t popup"

        bind G display-popup -E -T "popup"

        bind -n M-C attach-session -c "#{pane_current_path}"

        set -g status-keys emacs
        set -g allow-passthrough on
        set -g status-position top

        set -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",xterm-256color:RGB"

        set -g @resurrect-strategy-vim 'session'
        set -g @resurrect-strategy-nvim 'session'
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM

        set -gq allow-passthrough on
        set -g visual-activity off
      '';
  } // (lib.optionalAttrs (!useConfig) {
    clock24 = true;
    historyLimit = 1000000;
    baseIndex = 1;
    escapeTime = 0;
    newSession = true;
    aggressiveResize = true;
    shell = "${pkgs.fish}/bin/fish";
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    shortcut = "a";
    mouse = false;
  });
}
