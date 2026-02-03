{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    package = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [
        uosc
        sponsorblock
        quality-menu
        mpv-cheatsheet
        mpv-notify-send
        mpv-playlistmanager
        memo
      ];
    };

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      # cache-default is deprecated, using modern cache options
      demuxer-max-bytes = 4000000;
      cache = true;
      wayland = "yes";
    };
  };
}
