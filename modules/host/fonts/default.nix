{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.iosevka-term
      # nerd-fonts.iosevka
      #nerd-fonts.fira-code
      liberation_ttf
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Liberation Serif" "Vazirmatn"];
        sansSerif = ["Vazirmatn"];
        monospace = ["Fira Code"];
      };
    };
  };
}
