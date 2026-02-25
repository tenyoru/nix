{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    config.common.default = "gtk";
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-desktop-portal
  ];
}
