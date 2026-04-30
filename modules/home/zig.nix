{pkgs, ...}: {
  home.packages = [
    pkgs.zigpkgs."0.16.0"
  ];
}
