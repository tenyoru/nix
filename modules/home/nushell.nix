{
  config,
  mylib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.nushell];

  xdg.configFile."nushell".source =
    config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "nushell");
}
