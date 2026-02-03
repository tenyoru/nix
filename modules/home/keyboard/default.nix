{ config, pkgs, ... }:

{
  home.packages = [ pkgs.xorg.xkbcomp ]; # если нужно для отладки/установки

  xsession = {
    enable = true;
    initExtra = ''
      setxkbmap -layout us -variant qgmlwy -option
      xkbcomp ${../../../files/layouts/carpalx.xkb} $DISPLAY
    '';
  };

  home.keyboard = {
    layout = "us";
    variant = "qgmlwy";
  };
}
