{pkgs, ...}: {
  home.packages = [
    pkgs.zigpkgs.master
  ];
}
