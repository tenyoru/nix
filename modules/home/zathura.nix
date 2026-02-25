{
  config,
  mylib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.zathura];

  xdg.configFile."zathura".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "zathura");
}
