# Noctalia — Wayland desktop shell (Quickshell-based).
# The spotify-colors user template below renders into the writable
# colors.css that modules/home/spotify.nix symlinks into a mutable
# Spotify copy — keep the output_path in sync between the two files.
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
  pkgs,
  ...
}: let
  # spicetify Comfy color roles → noctalia palette, same mapping as the
  # community spicetify template, but rendered as xpui colors.css
  spotifyColorsTemplate = pkgs.writeText "spotify-colors.css" ''
    :root {
        --spice-main: {{colors.surface.default.hex}};
        --spice-main-elevated: {{colors.surface.default.hex}};
        --spice-main-transition: {{colors.surface_container_lowest.default.hex}};
        --spice-highlight: {{colors.surface_container_low.default.hex}};
        --spice-highlight-elevated: {{colors.surface_container_highest.default.hex}};
        --spice-sidebar: {{colors.surface.default.hex}};
        --spice-player: {{colors.surface.default.hex}};
        --spice-card: {{colors.surface.default.hex}};
        --spice-shadow: {{colors.surface.default.hex}};
        --spice-tab-active: {{colors.surface.default.hex}};
        --spice-misc: {{colors.surface.default.hex}};
        --spice-progress-bg: {{colors.surface.default.hex}};
        --spice-text: {{colors.on_surface.default.hex}};
        --spice-selected-row: {{colors.on_surface.default.hex}};
        --spice-subtext: {{colors.on_surface_variant.default.hex}};
        --spice-button: {{colors.primary.default.hex}};
        --spice-button-active: {{colors.primary.default.hex}};
        --spice-button-disabled: {{colors.primary.default.hex}};
        --spice-progress-fg: {{colors.primary.default.hex}};
        --spice-play-button: {{colors.secondary.default.hex}};
        --spice-play-button-active: {{colors.secondary.default.hex}};
        --spice-notification: {{colors.tertiary.default.hex}};
        --spice-notification-error: {{colors.error.default.hex}};
        --spice-heart: {{colors.error.default.hex}};
        --spice-pagelink-active: {{colors.on_tertiary_container.default.hex}};
        --spice-radio-btn-active: {{colors.on_tertiary_container.default.hex}};

        --spice-rgb-main: {{colors.surface.default.rgb_csv}};
        --spice-rgb-main-elevated: {{colors.surface.default.rgb_csv}};
        --spice-rgb-main-transition: {{colors.surface_container_lowest.default.rgb_csv}};
        --spice-rgb-highlight: {{colors.surface_container_low.default.rgb_csv}};
        --spice-rgb-highlight-elevated: {{colors.surface_container_highest.default.rgb_csv}};
        --spice-rgb-sidebar: {{colors.surface.default.rgb_csv}};
        --spice-rgb-player: {{colors.surface.default.rgb_csv}};
        --spice-rgb-card: {{colors.surface.default.rgb_csv}};
        --spice-rgb-shadow: {{colors.surface.default.rgb_csv}};
        --spice-rgb-tab-active: {{colors.surface.default.rgb_csv}};
        --spice-rgb-misc: {{colors.surface.default.rgb_csv}};
        --spice-rgb-progress-bg: {{colors.surface.default.rgb_csv}};
        --spice-rgb-text: {{colors.on_surface.default.rgb_csv}};
        --spice-rgb-selected-row: {{colors.on_surface.default.rgb_csv}};
        --spice-rgb-subtext: {{colors.on_surface_variant.default.rgb_csv}};
        --spice-rgb-button: {{colors.primary.default.rgb_csv}};
        --spice-rgb-button-active: {{colors.primary.default.rgb_csv}};
        --spice-rgb-button-disabled: {{colors.primary.default.rgb_csv}};
        --spice-rgb-progress-fg: {{colors.primary.default.rgb_csv}};
        --spice-rgb-play-button: {{colors.secondary.default.rgb_csv}};
        --spice-rgb-play-button-active: {{colors.secondary.default.rgb_csv}};
        --spice-rgb-notification: {{colors.tertiary.default.rgb_csv}};
        --spice-rgb-notification-error: {{colors.error.default.rgb_csv}};
        --spice-rgb-heart: {{colors.error.default.rgb_csv}};
        --spice-rgb-pagelink-active: {{colors.on_tertiary_container.default.rgb_csv}};
        --spice-rgb-radio-btn-active: {{colors.on_tertiary_container.default.rgb_csv}};
    }
  '';
  tmuxColorsTemplate = pkgs.writeText "tmux-colors.conf" ''
    set -g status-style "bg={{colors.surface.default.hex}},fg={{colors.on_surface.default.hex}}"
    set -g status-left "#[fg={{colors.primary.default.hex}},bold] #S #[default]"
    set -g status-right "#[fg={{colors.on_surface_variant.default.hex}}]#{s|$HOME|~|:pane_current_path} "
    set -g window-status-format "#[fg={{colors.on_surface_variant.default.hex}}] #I:#W "
    set -g window-status-current-format "#[fg={{colors.primary.default.hex}},bold] #I:#W "
  '';
  # replaces the builtin niri template: same render, but the tab-indicator
  # inactive color maps to a dark surface tone instead of a near-identical
  # accent shade, so active/inactive tabs are distinguishable
  niriColorsTemplate = pkgs.writeText "niri-colors.kdl" ''
    layout {

        focus-ring {
            active-color   "{{colors.primary.default.hex}}"
            inactive-color "{{colors.surface.default.hex}}"
            urgent-color   "{{colors.error.default.hex}}"
        }

        border {
            active-color   "{{colors.primary.default.hex}}"
            inactive-color "{{colors.surface.default.hex}}"
            urgent-color   "{{colors.error.default.hex}}"
        }

        shadow {
            color "#00000070"
        }

        tab-indicator {
            active-color   "{{colors.primary.default.hex}}"
            inactive-color "{{colors.surface_container_high.default.hex}}"
            urgent-color   "{{colors.error.default.hex}}"
        }

        insert-hint {
            color "{{colors.primary.default.hex}}80"
        }
    }

    recent-windows {
        highlight {
            active-color "{{colors.primary.default.hex}}"
            urgent-color "{{colors.error.default.hex}}"
        }
    }
  '';
  opencodeColorsTemplate = pkgs.writeText "opencode-matugen.json" ''
    {
      "$schema": "https://opencode.ai/theme.json",
      "defs": {
        "primary": "{{colors.primary.default.hex}}",
        "on_primary": "{{colors.on_primary.default.hex}}",
        "secondary": "{{colors.secondary.default.hex}}",
        "on_secondary": "{{colors.on_secondary.default.hex}}",
        "surface": "{{colors.surface.default.hex}}",
        "on_surface": "{{colors.on_surface.default.hex}}",
        "surface_variant": "{{colors.surface_variant.default.hex}}",
        "on_surface_variant": "{{colors.on_surface_variant.default.hex}}",
        "background": "{{colors.surface.default.hex}}",
        "on_background": "{{colors.on_surface.default.hex}}",
        "error": "{{colors.error.default.hex}}",
        "on_error": "{{colors.on_error.default.hex}}",
        "outline": "{{colors.outline.default.hex}}",
        "outline_variant": "{{colors.outline_variant.default.hex}}"
      },
      "theme": {
        "primary": { "dark": "primary", "light": "primary" },
        "secondary": { "dark": "secondary", "light": "secondary" },
        "accent": { "dark": "primary", "light": "primary" },
        "error": { "dark": "error", "light": "error" },
        "warning": { "dark": "secondary", "light": "secondary" },
        "success": { "dark": "secondary", "light": "secondary" },
        "info": { "dark": "primary", "light": "primary" },
        "text": { "dark": "on_surface", "light": "on_surface" },
        "textMuted": { "dark": "on_surface_variant", "light": "on_surface_variant" },
        "background": { "dark": "background", "light": "background" },
        "backgroundPanel": { "dark": "surface_variant", "light": "surface_variant" },
        "backgroundElement": { "dark": "surface_variant", "light": "surface_variant" },
        "border": { "dark": "outline_variant", "light": "outline_variant" },
        "borderActive": { "dark": "outline", "light": "outline" },
        "borderSubtle": { "dark": "outline_variant", "light": "outline_variant" },
        "diffAdded": { "dark": "secondary", "light": "secondary" },
        "diffRemoved": { "dark": "error", "light": "error" },
        "diffContext": { "dark": "surface_variant", "light": "surface_variant" },
        "diffHunkHeader": { "dark": "surface_variant", "light": "surface_variant" },
        "diffHighlightAdded": { "dark": "secondary", "light": "secondary" },
        "diffHighlightRemoved": { "dark": "error", "light": "error" },
        "diffAddedBg": { "dark": "surface_variant", "light": "surface_variant" },
        "diffRemovedBg": { "dark": "surface_variant", "light": "surface_variant" },
        "diffContextBg": { "dark": "surface_variant", "light": "surface_variant" },
        "diffLineNumber": { "dark": "on_surface_variant", "light": "on_surface_variant" },
        "diffAddedLineNumberBg": { "dark": "surface_variant", "light": "surface_variant" },
        "diffRemovedLineNumberBg": { "dark": "surface_variant", "light": "surface_variant" },
        "markdownText": { "dark": "on_surface", "light": "on_surface" },
        "markdownHeading": { "dark": "primary", "light": "primary" },
        "markdownLink": { "dark": "primary", "light": "primary" },
        "markdownLinkText": { "dark": "secondary", "light": "secondary" },
        "markdownCode": { "dark": "secondary", "light": "secondary" },
        "markdownBlockQuote": { "dark": "surface_variant", "light": "surface_variant" },
        "markdownEmph": { "dark": "secondary", "light": "secondary" },
        "markdownStrong": { "dark": "primary", "light": "primary" },
        "markdownHorizontalRule": { "dark": "surface_variant", "light": "surface_variant" },
        "markdownListItem": { "dark": "primary", "light": "primary" },
        "markdownListEnumeration": { "dark": "secondary", "light": "secondary" },
        "markdownImage": { "dark": "primary", "light": "primary" },
        "markdownImageText": { "dark": "secondary", "light": "secondary" },
        "markdownCodeBlock": { "dark": "on_surface", "light": "on_surface" },
        "syntaxComment": { "dark": "on_surface_variant", "light": "on_surface_variant" },
        "syntaxKeyword": { "dark": "primary", "light": "primary" },
        "syntaxFunction": { "dark": "secondary", "light": "secondary" },
        "syntaxVariable": { "dark": "on_surface", "light": "on_surface" },
        "syntaxString": { "dark": "secondary", "light": "secondary" },
        "syntaxNumber": { "dark": "secondary", "light": "secondary" },
        "syntaxType": { "dark": "primary", "light": "primary" },
        "syntaxOperator": { "dark": "on_surface", "light": "on_surface" },
        "syntaxPunctuation": { "dark": "on_surface_variant", "light": "on_surface_variant" }
      }
    }
  '';
in {
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
        workspaces.show_labels = false;
        nix_monitor.type = "avivbintangaringga/nix-monitor:nix-monitor";
      };

      plugins.enabled = ["avivbintangaringga/nix-monitor"];

      plugin_settings."avivbintangaringga/nix-monitor" = {
        # the system builds from the nixpkgs-unstable channel (inputs.unstable),
        # not the nixos-unstable branch the plugin defaults to
        branch = "nixpkgs-unstable";
        show_update_available_notification = false;
        update_command = "cd ${config.home.homeDirectory}/.nixos && just update-switch";
        clean_command = "cd ${config.home.homeDirectory}/.nixos && just gc";
      };

      # renders the blurred overview wallpaper layer that the
      # `^noctalia-backdrop` layer-rule in niri/config.kdl places in the backdrop
      backdrop.enabled = true;

      theme = {
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
        templates = {
          user.niri-colors = {
            input_path = "${niriColorsTemplate}";
            output_path = "${config.home.homeDirectory}/.config/niri/noctalia.kdl";
            post_hook = "niri msg action load-config-file";
          };
          builtin_ids = [];
          community_ids = [];
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
