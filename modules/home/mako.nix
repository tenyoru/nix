{ config, mylib, pkgs, ... }:
{
  home.packages = [ pkgs.mako ];

  xdg.configFile."mako".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "mako");
}
