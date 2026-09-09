{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.iosevka-term
      jetbrains-mono
      monocraft
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
