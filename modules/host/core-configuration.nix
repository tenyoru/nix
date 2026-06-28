{hostConfig, ...}: {
  documentation.nixos.enable = false;

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
    ];
    element-web.conf = {
      show_labs_settings = true;
      default_theme = "dark";
    };
  };

  system.stateVersion = hostConfig.stateVersion;
}
