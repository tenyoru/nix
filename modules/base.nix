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

  nix.package = pkgs.nixVersions.latest;

  environment.systemPackages = with pkgs; [
    # core tools
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkg-config
    # secrets management
    sops
    age
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
