{ config, mylib, pkgs, ... }:
{
  home.packages = [ pkgs.qutebrowser ];

  xdg.configFile."qutebrowser".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "qutebrowser");
}
