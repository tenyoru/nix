{ pkgs, ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      openssl
      zlib
      glib
      stdenv.cc.cc.lib
    ];
  };
}
