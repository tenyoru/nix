{
  lib,
  pkgs,
  nixos-raspberrypi,
  ...
}: {
  # inject-overlays is only needed for the "advanced" manual
  # nixpkgs.lib.nixosSystem path — nixos-raspberrypi.lib.nixosSystem (what
  # we use, see outputs.nix) applies it internally; adding it again here
  # double-applied the overlay and caused an infinite recursion
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.bluetooth
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # matches the partition labels nixos-raspberrypi's own
  # rpi5-installer sd-image uses. Deploy by flashing their installer image
  # once, then `nixos-rebuild switch --target-host` this config onto it —
  # simpler than wiring up disko for a one-step nixos-anywhere deploy
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
  };

  # RPi hands out DTBs via firmware/config.txt (raspberrypifw),
  # not the generic NixOS hardware.deviceTree module — its default eval
  # crashes on nixos-raspberrypi's kernel (no buildDTBs passthru)
  hardware.deviceTree.enable = lib.mkForce false;

  # "kernel" is the new generational bootloader (multiple
  # generations, works with nixos-rebuild --target-host), recommended by
  # nixos-raspberrypi for new installs over the legacy "kernelboot" default
  boot.loader.raspberry-pi.bootloader = "kernel";

  networking.hostName = "pi5";
  networking.networkmanager.enable = true;

  # no home-manager here (see outputs.nix) — plain packages instead
  environment.systemPackages = with pkgs; [git neovim tmux];
}
