{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.millennium-steam;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];
}
