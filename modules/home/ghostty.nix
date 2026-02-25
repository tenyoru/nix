{
  config,
  mylib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.ghostty];

  xdg.configFile."ghostty".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "ghostty");
}
