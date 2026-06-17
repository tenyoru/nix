{
  pkgs,
  hostConfig,
  inputs,
  mylib,
  ...
}: let
  username = hostConfig.username;
in {
  documentation.nixos.enable = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.millennium.overlays.default
    inputs.zig-overlay.overlays.default
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
