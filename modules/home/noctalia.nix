# Noctalia — Wayland desktop shell (Quickshell-based).
# Docs (v5 config schema): https://docs.noctalia.dev/v5/
#   Bar widgets:   https://docs.noctalia.dev/v5/bar/widgets/
#   Theming:       https://docs.noctalia.dev/v5/theming/
#   Niri setup:    https://docs.noctalia.dev/v5/compositor-settings/niri/
# Source: https://github.com/noctalia-dev/noctalia
# Full schema with defaults: `noctalia config export full`
# Validate config:           `noctalia config validate`
# Template ids:              `noctalia theme --list-templates`
# nix-monitor plugin: https://github.com/noctalia-dev/community-plugins
{
  config,
  inputs,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;
    # noctalia v5 config schema (snake_case); validate with `noctalia config validate`
    settings = {
      bar.widgets = {
        position = "top";
        capsule = true;
        background_opacity = 0.85;
        margin_edge = 6;
        margin_ends = 12;
        start = ["launcher" "clock" "cpu" "ram" "active_window" "media"];
        center = ["workspaces"];
        end = ["nix_monitor" "tray" "notifications" "battery" "volume" "brightness" "control-center"];
      };

      widget = {
        workspaces.display = "none";
        nix_monitor.type = "avivbintangaringga/nix-monitor:nix-monitor";
      };

      plugins.enabled = ["avivbintangaringga/nix-monitor"];

      plugin_settings."avivbintangaringga/nix-monitor" = {
        update_command = "cd ${config.home.homeDirectory}/.nixos && just update-switch";
        clean_command = "cd ${config.home.homeDirectory}/.nixos && just gc";
      };

      theme = {
        source = "wallpaper";
        wallpaper_scheme = "m3-monochrome";
        templates = {
          builtin_ids = ["btop" "ghostty" "gtk3" "gtk4" "niri" "qt"];
          community_ids = [
            "bat"
            "discord"
            "fuzzel"
            "neovim"
            "obs"
            "obsidian"
            "opencode"
            "prismlauncher"
            "spicetify"
            "steam"
            "telegram"
            "yazi"
            "zathura"
            "zen-browser"
          ];
        };
      };

      location.address = "Liege, Belgium";

      shell.avatar_path = "${config.home.homeDirectory}/.face";

      idle.behavior = {
        "screen-off" = {
          enabled = true;
          timeout = 600.0;
        };
        lock = {
          enabled = true;
          timeout = 660.0;
        };
        "lock-and-suspend" = {
          enabled = true;
          timeout = 1800.0;
        };
      };

      wallpaper = {
        enabled = true;
        directory = "${config.home.homeDirectory}/.nixos/dotfiles/wallpapers/noctalia";
        fill_mode = "crop";
        transition = ["fade" "wipe"];
        transition_duration = 1200.0;
        automation = {
          enabled = true;
          interval_seconds = 900;
          order = "random";
        };
      };
    };
  };
}
