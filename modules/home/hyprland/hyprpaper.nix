{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "/etc/nixos/wallpapers/flowers.jpg"
        "/etc/nixos/wallpapers/rockman.png"
      ];

      wallpaper = [
        "DP-2,/etc/nixos/wallpapers/flowers.jpg"
        "eDP-1,/etc/nixos/wallpapers/rockman.png"
      ];
    };
  };
}
