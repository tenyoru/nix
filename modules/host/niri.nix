{
  pkgs,
  hostConfig,
  mylib,
  ...
}: let
  niriDir = mylib.dotfileConfig "niri";
in {
  programs.niri = {
    enable = true;
    # bare `import-environment` trips a systemd deprecation warning at session
    # start; an explicit list of every exported var is the same behavior, silent
    package = pkgs.niri.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          substituteInPlace $out/bin/niri-session \
            --replace-fail 'systemctl --user import-environment' \
              'systemctl --user import-environment $(compgen -e)'
        '';
    });
  };

  # Re-prompt for the current task on resume from suspend/hibernate (niri
  # start-up itself is handled by spawn-at-startup in config.kdl, since a
  # real resume doesn't re-run that).
  powerManagement.resumeCommands = ''
    export XDG_RUNTIME_DIR="/run/user/$(${pkgs.coreutils}/bin/id -u ${hostConfig.username})"
    ${pkgs.util-linux}/bin/runuser -u ${hostConfig.username} -- systemctl --user start task-gate.service
  '';

  home-manager.users.${hostConfig.username} = {config, ...}: {
    # niri itself comes from programs.niri above (patched package)
    home.packages = with pkgs; [
      playerctl
      wl-clipboard
      xdg-utils
      xdg-desktop-portal
      fuzzel
    ];

    systemd.user.services.task-gate = {
      Unit.Description = "Prompt for the current task";
      Service = {
        Type = "oneshot";
        ExecStart = "${niriDir}/scripts/task-gate.sh";
      };
    };

    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = ["gnome"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
          "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };

    xdg.configFile."niri".source =
      config.lib.file.mkOutOfStoreSymlink niriDir;

    home.sessionVariables = {
      NIRI_RUN_SCRIPT = "${niriDir}/scripts/focus-or-launch.sh";
      NIRI_SCRIPTS = "${niriDir}/scripts";
    };
  };
}
