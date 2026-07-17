{pkgs, ...}: {
  gtk = {
    enable = true;
    font.name = "Liberation";
    theme = {
      name = "Gruvbox-Gtk-Theme";
      package = pkgs.gruvbox-gtk-theme;
    };
  };

  # qt apps (obs, mpv scripts, …) read noctalia's generated color
  # schemes through qt5ct/qt6ct; pick "noctalia" once in qt6ct
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.packages = with pkgs; [qt6ct];
}
