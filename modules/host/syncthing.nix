{
  config,
  pkgs,
  hostConfig,
  ...
}: let
  username = hostConfig.username;
  homeDir = "/home/${username}";
in {
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = homeDir;
    configDir = "${homeDir}/.config/syncthing";
  };
}
