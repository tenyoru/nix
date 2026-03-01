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
    openssh
    curl
    wget
  ];

  # Set default shell
  user.shell = "${pkgs.fish}/bin/fish";

  # Enable SSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Setup SSH directory
  build.activation.sshd = ''
    $DRY_RUN_CMD mkdir -p $HOME/.ssh
    $DRY_RUN_CMD chmod 700 $HOME/.ssh
  '';
}
