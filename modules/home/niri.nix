{ config, pkgs, mylib, ... }:

let
  niriDir = mylib.dotfileConfig "niri";
in
{
  home.packages = [
    pkgs.niri
    pkgs.playerctl
    pkgs.wl-clipboard
  ];

  xdg.configFile."niri".source =
    config.lib.file.mkOutOfStoreSymlink niriDir;

  home.sessionVariables = {
    NIRI_RUN_SCRIPT = "${niriDir}/scripts/focus-or-launch.sh";
    NIRI_SCRIPTS = "${niriDir}/scripts";
  };
}
