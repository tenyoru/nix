{pkgs, ...}: {
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-desktop-portal
  ];
}
