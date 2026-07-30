{hostConfig, ...}: {
  documentation.nixos.enable = false;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-40.10.5"
    ];
    element-web.conf = {
      show_labs_settings = true;
      default_theme = "dark";
    };
  };

  system.stateVersion = hostConfig.stateVersion;
}
