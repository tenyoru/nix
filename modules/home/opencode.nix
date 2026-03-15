{
  config,
  mylib,
  ...
}: {
  xdg.configFile."opencode".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "opencode");
}
