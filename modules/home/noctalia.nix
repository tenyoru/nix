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
    };
  };
}
