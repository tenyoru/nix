{
  config,
  mylib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.ghostty pkgs.chafa];

  xdg.configFile."ghostty".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "ghostty");
}
