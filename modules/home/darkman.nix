{pkgs, ...}: {
  services.darkman = {
    enable = true;
    settings.useGeoclue = true;
    lightModeScripts.color-scheme = ''
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    '';
    darkModeScripts.color-scheme = ''
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    '';
  };
}
