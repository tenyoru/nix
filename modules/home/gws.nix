{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.googleworkspace-cli.packages.${pkgs.stdenv.hostPlatform.system}.gws
  ];
}
