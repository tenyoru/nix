{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    config = {
      common.default = ["gtk"];
      niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-desktop-portal
  ];
}
