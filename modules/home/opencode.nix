{
  config,
  mylib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.openspec];
  xdg.configFile."opencode".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "opencode");
}
