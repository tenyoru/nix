{
  path,
  mylib,
  ...
}: let
  homeModules = import ./home.nix {inherit mylib;};
in {
  username = "Tenyoru";
  name = "phone";
  platform = "aarch64-linux";
  type = "nix-on-droid";

  modules = {
    home = homeModules.imports;
    nix-on-droid = [./nix-on-droid.nix];
  };
}
