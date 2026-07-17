{
  pkgs,
  hostConfig,
  inputs,
  mylib,
  lib,
  ...
}: let
  username = hostConfig.username;
in {
  documentation.nixos.enable = false;
  nixpkgs.config.allowUnfree = true;
  # ponytail: these overlays are x86-desktop-oriented (Steam mod, claude-code
  # linux-x64 binary) and collide with nixos-raspberrypi's own overlay stack
  # (infinite recursion) — skip them on Pi hosts
  nixpkgs.overlays = lib.optionals (!(hostConfig.raspberrypi or false)) [
    inputs.millennium.overlays.default
    inputs.zig-overlay.overlays.default
    # ponytail: pins claude-code newer than nixpkgs; bump version+hash to update
    (final: prev: {
      claude-code = prev.claude-code.overrideAttrs (old: rec {
        version = "2.1.201";
        src = final.fetchurl {
          url = "https://downloads.claude.ai/claude-code-releases/${version}/linux-x64/claude";
          hash = "sha256-o0gJpoOf3v/yG5NH1/tba1jmqcwgil5ihT8pyD6xB6M=";
        };
      });
    })
  ];

  nix.package = pkgs.nixVersions.latest;

  environment.systemPackages = with pkgs; [
    # core tools
    neovim
    pkg-config
    # secrets management
    sops
    age
    pciutils
  ];

  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
    trusted-users = [username];
    builders-use-substitutes = true;
  };

  programs.nano.enable = false;
  programs.fish.enable = true;
}
