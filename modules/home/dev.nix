{ pkgs, ... }: {
  home.packages = with pkgs; [
    clang # need for neovim
    clang-tools

    #latex
    texlab
    tectonic

    usbutils # need for embedded
  ];
}
