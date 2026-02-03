{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font.name = "Liberation";
    theme = {
      name = "Gruvbox-Gtk-Theme";
      package = pkgs.gruvbox-gtk-theme;
    };
  };
}
