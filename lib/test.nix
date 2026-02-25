let
  mylib = import ../lib {
    self = ../.;
    lib = import <nixpkgs> {};
  };
  homeModules = mylib.getHomeModules [];
  hostModules = mylib.getHostModules ["fonts" "locale" "audio" "dadadda"];
  dirModules = mylib.getDirModules "../hosts/laptop-core";
  scanPaths = mylib.scanPaths "/etc/nixos/hosts/laptop-core/";
in
  # hostModules
  # dirModules
  scanPaths
