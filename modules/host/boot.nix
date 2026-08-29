{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    initrd = {
      kernelModules = ["amdgpu"];
      systemd.enable = true;
      verbose = false;
    };

    # Use the systemd-boot EFI boot loader.
    loader = {
      timeout = 2;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };

    # Resume from the /.swapfile on hibernate. systemd's automatic swapfile
    # resume detection was unreliable here (journal showed repeated
    # "Unable to resume ... continuing boot process" after every real
    # hibernation attempt), so pin device + offset explicitly.
    # Recompute offset with: filefrag -v /.swapfile | awk '$1=="0:" {print $4}' (strip the trailing '..')
    resumeDevice = "/dev/disk/by-uuid/f3f670ff-b051-4524-a50d-80cea5349557";

    consoleLogLevel = 0;
    kernelParams = [
      # "systemd.mask=systemd-vconsole-setup.service"
      # "systemd.mask=dev-tpmrm0.device"
      "apm=power_off"
      "amdgpu.dc=1"
      "amdgpu.dcdebugmask=0x10"
      "amdgpu.aspm=0" # possible fix for black screen/hang on resume from s2idle
      # GPU is Rembrandt (0x1002:0x15bf), which has a known firmware bug where
      # GFXOFF entered right before suspend never signals back on s2idle resume
      # (journal: "SMU is resumed successfully!" just never appears, machine
      # hangs and needs a hard power-cycle). Disable PP_GFXOFF_MASK (bit 15).
      "amdgpu.ppfeaturemask=0xffff7fff"
      "resume_offset=882688" # physical offset of /.swapfile, confirmed by systemd-hibernate-resume in journal
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
