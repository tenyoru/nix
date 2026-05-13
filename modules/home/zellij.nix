{
  config,
  lib,
  mylib,
  hostConfig,
  pkgs,
  ...
}: let
  useConfig = mylib.useDotfiles hostConfig;
in {
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
  };

  xdg.configFile."zellij".source = lib.mkIf useConfig
    (config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "zellij"));
}
