{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}: let
  username = hostConfig.username;
in {
  documentation.nixos.enable = false;
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-38.8.4"
    ];
    element-web.conf = {
      show_labs_settings = true;
      default_theme = "dark";
    };
  };

  # environment.etc."xkb/symbols/qgmlwy".source = ../../files/layouts/carpalx.xkb;

  system.stateVersion = hostConfig.stateVersion;
}
