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

  home-manager.users.${hostConfig.username} = {config, ...}: {
    # niri itself comes from programs.niri above (patched package)
    home.packages = with pkgs; [
      playerctl
      wl-clipboard
      xdg-utils
      xdg-desktop-portal
    ];

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
