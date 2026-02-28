{
  path,
  mylib,
  ...
}: let
  dirModules = mylib.scanPaths path;
  hostModules = import ./host.nix {inherit mylib;};
  homeModules = import ./home.nix {inherit mylib;};
in {
  username = "Tenyoru";
  name = "core";
  platform = "x86_64-linux";

  dotfiles = {
    enable = true;
    bin = true;
  };

  modules = {
    host = dirModules ++ hostModules.imports;
    home = homeModules.imports;
  };
}
