{ config, mylib, pkgs, ... }:
{
  home.packages = [ pkgs.chawan ];

  xdg.configFile."chawan".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "chawan");
}
