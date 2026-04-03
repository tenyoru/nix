{
  config,
  inputs,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        position = "top";
        displayMode = "auto_hide";
        autoHideDelay = 300;
        autoShowDelay = 0;
        showOnWorkspaceSwitch = false;
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "Launcher";
            }
            {
              id = "Clock";
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };

      colorSchemes.predefinedScheme = "Monochrome";

      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "${config.home.homeDirectory}/.nixos/dotfiles/wallpapers/noctalia";
        fillMode = "crop";
        setWallpaperOnAllMonitors = true;
        linkLightAndDarkWallpapers = true;
        automationEnabled = true;
        wallpaperChangeMode = "random";
        randomIntervalSec = 900;
        transitionDuration = 1200;
        transitionType = [
          "fade"
          "wipe"
        ];
      };

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        radiusRatio = 0.2;
        compactLockScreen = false;
        lockOnSuspend = true;
        lockScreenAnimations = true;
        showSessionButtonsOnLockScreen = true;
        enableLockScreenMediaControls = true;
        enableLockScreenCountdown = true;
        lockScreenCountdownDuration = 10000;
      };

      location = {
        monthBeforeDay = true;
        name = "Liege, Belgium";
      };

      templates = {
        activeTemplates = [
          {
            id = "spicetify";
            enabled = true;
          }
          {
            id = "zenBrowser";
            enabled = true;
          }
        ];
      };

      idle = {
        enabled = true;
        screenOffTimeout = 600;
        lockTimeout = 660;
        suspendTimeout = 1800;
        fadeDuration = 5;
      };
    };
  };
}
