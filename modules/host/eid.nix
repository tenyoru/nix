{pkgs, ...}: {
  services.pcscd.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="2ce3", ATTR{idProduct}=="9563", GROUP="pcscd", MODE="0664"
  '';

  environment.systemPackages = with pkgs; [
    pcsc-tools
    ccid
    eid-mw
  ];
}
