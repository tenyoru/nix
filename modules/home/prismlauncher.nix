{pkgs, ...}: {
  home.packages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = [ffmpeg];
      jdks = [zulu21];
    })
  ];
}
