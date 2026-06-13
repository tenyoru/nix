{
  config,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  noctaliaEnabled = config.programs.noctalia.enable or false;
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
      playlistIcons
      historyShortcut
    ];

    theme = if noctaliaEnabled then spicePkgs.themes.comfy else spicePkgs.themes.text;
    colorScheme = if noctaliaEnabled then "Comfy" else "Nord";
  };
}
