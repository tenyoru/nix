{
  config,
  lib,
  pkgs,
  ...
}: {
  # Set time zone
  time.timeZone = "Europe/Warsaw";

  # Enable nix flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Basic environment packages
  environment.packages = with pkgs; [
    git
    curl
    wget
  ];

  # Set default shell
  user.shell = "${pkgs.fish}/bin/fish";
}
