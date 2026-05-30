{
  config,
  pkgs,
  mylib,
  ...
}: let
  niriDir = mylib.dotfileConfig "niri";
in {
  home.packages = with pkgs; [
    niri
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
}
