{ pkgs, ... }:

let
  alphabet = ["a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"];

  generateKeyBindings = action: builtins.concatStringsSep "" (builtins.map (key: ''
    bind = , ${key}, scroller:${action}, ${key}
    bind = , ${key}, submap, reset
  '') alphabet);
in

{
  home.packages = with pkgs; [
    # waybar
    wl-clipboard
    mako
    hyprcursor
    hypridle
    lm_sensors
    hyprshot
    hyprland-protocols
  ];

  imports = [
      ../anyrun.nix
      ./hyprpaper.nix
      ./hyprlock.nix
      ./hypridle.nix
    ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    plugins = [
      pkgs.hyprlandPlugins.hyprscroller
    ];

    systemd.variables = ["--all"];
    settings = {
        monitor = [
          "eDP-1, 1920x1200@60, 0x0, 1"
          "DP-2, 3840x2160@120, -3840x0,1"
        ];
        exec-once = [
          "foot --server"
          "mako"
          #"waybar"
          "hypridle"
          "mpd --no-daemon ~/.config/mpd/mpd.conf"
        ];

        env = [
          # "WLR_NO_HARDWARE_CURSORS,1"
          "GTK_THEME,Gruvbox-Dark"

          #useless shit
          "HYPRCURSOR_THEME,Notwaita-Black"
          "HYPRCURSOR_SIZE,24"
          "XCURSOR_THEME,Notwaita-Black"
          "XCURSOR_SIZE,24"
          "NIXOS_OZONE_WL,1"
          "BROWSER,librewolf"
          # "XDG_BROWSER=librewolf"
        ];

        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;

          resize_on_border = false;
          allow_tearing = true;
          layout = "scroller";

          "col.active_border" = "rgb(ebdbb2)";
          "col.inactive_border" = "rgb(282828)";
        };

        decoration = {
            rounding = 0;

            active_opacity = 1.0;
            inactive_opacity = 1.0;

            # drop_shadow = true;
            # shadow_range = 4;
            # shadow_render_power = 3;

            blur = {
                enabled = true;
                size = 3;
                passes = 1;

                vibrancy = 0.1696;
            };
        };

        input = {
            kb_layout = "us,ru";
            kb_options = "grp:win_space_toggle";

            follow_mouse = 1;

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

            touchpad = {
                natural_scroll = false;
            };
        };

        misc = {
            disable_splash_rendering = true;
            disable_hyprland_logo = true;
            background_color = "0x121212";
        };

        gestures = {
            workspace_swipe = false;
        };

        cursor = {
            enable_hyprcursor = false;
        };

        animations = {
            enabled = false;

            # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation =
              [
                "windows, 1, 7, myBezier"
                "windowsOut, 1, 7, default, popin 80%"
                "border, 1, 10, default"
                "borderangle, 1, 8, default"
                "fade, 1, 7, default"
                "workspaces, 1, 6, default"
              ];
        };

        "$mod" = "SUPER";

        bind = [
          "$mod, C, killactive,"
          "$mod SHIFT, O, exit,"
          "$mod, Q, exec, footclient"
          "$mod, R, exec, anyrun"
          "$mod, F, fullscreen,"
          "$mod, V, togglefloating,"
          "$mod SHIFT, P, pin,"
          ", Print, exec, grimblast copy area"

          "$mod, home, scroller:movefocus, begin"
          "$mod, end, scroller:movefocus, end"
          "$mod, l, scroller:movefocus, right"
          "$mod, h, scroller:movefocus, left"
          "$mod, k, scroller:movefocus, up"
          "$mod, j, scroller:movefocus, down"

          "$mod SHIFT, h, scroller:movewindow, l"
          "$mod SHIFT, l, scroller:movewindow, r"
          "$mod SHIFT, k, scroller:movewindow, u"
          "$mod SHIFT, j, scroller:movewindow, d"
          "$mod SHIFT, home, scroller:movewindow, begin"
          "$mod SHIFT, end, scroller:movewindow, end"

          "$mod, bracketleft, scroller:setmode, row"
          "$mod, bracketright, scroller:setmode, col"

          "$mod, equal, scroller:cyclesize, next"
          "$mod, minus, scroller:cyclesize, prev"

          "$mod SHIFT, i, scroller:fitsize, active"

          "$mod, I, scroller:admitwindow,"
          "$mod, O, scroller:expelwindow,"

          "$mod, XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          "$mod, XF86MonBrightnessUp, exec, brightnessctl set 5%+"

          "$mod, XF86AudioRaiseVolume, exec, wireplumber --pipe 'set-volume @DEFAULT_AUDIO_SINK@ 5%+'"
          "$mod, XF86AudioLowerVolume, exec, wireplumber --pipe 'set-volume @DEFAULT_AUDIO_SINK@ 5%-'"

          "$mod, XF86AudioMute, exec, wireplumber --pipe 'set-sink-mute @DEFAULT_SINK@ toggle'"
          "$mod, XF86AudioMicMute, exec, wireplumber --pipe 'set-source-mute @DEFAULT_SOURCE@ toggle'"

          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86audiostop, exec, playerctl stop"

          ", PRINT, exec, hyprshot -m output -o ~/Photos/Screenshots/"
          "SHIFT, PRINT, exec, hyprshot -m region -o ~/Photos/Screenshots/"
          "$mod, PRINT, exec, hyprshot -m window -o ~/Photos/Screenshots/"
          "CTRL, PRINT, exec, hyprshot -m output --clipboard-only"
          "CTRL SHIFT, PRINT, exec, hyprshot -m region --clipboard-only"
          "CTRL $mod, PRINT, exec, hyprshot -m window --clipboard-only"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.* "
          "idleinhibit fullscreen, class:^(*)$"
          "idleinhibit fullscreen, title:^(*)$"
          "idleinhibit fullscreen, fullscreen:1"
        ];
    };

    extraConfig = ''
      bind = $mod, tab, scroller:toggleoverview
      # overview submap
      # will switch to a submap called overview
      bind = $mod, tab, submap, overview
      # will start a submap called "overview"
      submap = overview

      bind = $mod, l, scroller:movefocus, right
      bind = $mod, h, scroller:movefocus, left
      bind = $mod, k, scroller:movefocus, up
      bind = $mod, j, scroller:movefocus, down

      bind = $mod SHIFT, h, scroller:movewindow, l
      bind = $mod SHIFT, l, scroller:movewindow, r
      bind = $mod SHIFT, k, scroller:movewindow, u
      bind = $mod SHIFT, j, scroller:movewindow, d
      bind = $mod SHIFT, home, scroller:movewindow, begin
      bind = $mod SHIFT, end, scroller:movewindow, end

      bind = $mod, C, killactive,

      # use reset to go back to the global submap
      bind = , escape, scroller:toggleoverview,
      bind = , escape, submap, reset
      bind = , return, scroller:toggleoverview,
      bind = , return, submap, reset
      bind = $mod, tab, scroller:toggleoverview,
      bind = $mod, tab, submap, reset
      bind = , tab, scroller:toggleoverview,
      bind = , tab, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset

      bind = $mod SHIFT, R, submap, resize
      submap = resize
      bind = , l, resizeactive, 100 0
      bind = , h, resizeactive, -100 0
      bind = , k, resizeactive, 0 -100
      bind = , j, resizeactive, 0 100
      bind = , escape, submap, reset
      submap = reset

      bind = $mod, S, submap, center
      submap = center
      bind = , C, scroller:alignwindow, c
      bind = , C, submap, reset
      bind = , l, scroller:alignwindow, r
      bind = , l, submap, reset
      bind = , h, scroller:alignwindow, l
      bind = , h, submap, reset
      bind = , k, scroller:alignwindow, u
      bind = , k, submap, reset
      bind = , j, scroller:alignwindow, d
      bind = , j, submap, reset
      bind = , escape, submap, reset
      submap = reset

      bind = $mod, W, submap, fitsize
      submap = fitsize
      bind = , W, scroller:fitsize, visible
      bind = , W, submap, reset
      bind = , right, scroller:fitsize, toend
      bind = , right, submap, reset
      bind = , left, scroller:fitsize, tobeg
      bind = , left, submap, reset
      bind = , up, scroller:fitsize, active
      bind = , up, submap, reset
      bind = , down, scroller:fitsize, all
      bind = , down, submap, reset
      bind = , escape, submap, reset
      submap = reset

      # Marks Add submap (Mod+M)
      bind = $mod, M, submap, marksadd
      submap = marksadd

      # Generate key bindings for marksadd (a to z)
      ${generateKeyBindings "marksadd"}

      bind = , escape, submap, reset
      submap = reset

      # Marks Delete submap (Mod+Shift+M)
      bind = $mod SHIFT, M, submap, marksdelete
      submap = marksdelete

      # Generate key bindings for marksdelete (a to z)
      ${generateKeyBindings "marksdelete"}

      bind = , escape, submap, reset
      submap = reset

      # Marks Visit submap (Mod+')
      bind = $mod, apostrophe, submap, marksvisit
      submap = marksvisit

      # Generate key bindings for marksvisit (a to z)
      ${generateKeyBindings "marksvisit"}

      bind = , escape, submap, reset
      submap = reset

      # Reset all marks (Mod+Ctrl+M)
      bind = $mod CTRL, M, scroller:marksreset
    '';
  };
}
