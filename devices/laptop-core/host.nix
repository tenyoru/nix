{mylib, ...}: {
  imports = mylib.getHostModules [
    "fonts"
    "locale"
    "audio"
    "nix"
    "user"
    "ssh"
    "wayland"
    "virtualisation"
    "docker"
    "boot"
    "hardware"
    "networking"
    "programs"
    "services"
    "syncthing"
    # "steam"
    ({pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        git
        webkitgtk_4_1
        networkmanager
      ];
    })
    ./secrets.nix
  ];
}
