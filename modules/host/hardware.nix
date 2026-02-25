{...}: {
  hardware = {
    keyboard.qmk.enable = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true; # for gnome-bluetooth percentage
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [];
      # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };
}
