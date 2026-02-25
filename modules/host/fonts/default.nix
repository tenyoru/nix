{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.iosevka-term
      # nerd-fonts.iosevka
      #nerd-fonts.fira-code
      liberation_ttf
      # vazir-fonts
      #nerd-fonts._0xproto
      monocraft
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
