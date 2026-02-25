{ pkgs, hostConfig, ... }: {
  users.groups.libvirtd.members = [ hostConfig.username ];

  boot.kernelModules = ["kvm-amd"];
  boot.extraModprobeConfig = "options kvm_amd nested=1";

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;

    # libvirtd = {
    #   enable = true;
    #   # hanging this option to false may cause file permission issues for existing guests.
    #   # To fix these, manually change ownership of affected files in /var/lib/libvirt/qemu to qemu-libvirtd.
    #   qemu.runAsRoot = true;
    # };

    # lxd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virt-manager
  ];

  services.spice-vdagentd.enable = true;
}
