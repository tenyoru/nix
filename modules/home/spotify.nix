{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  noctaliaEnabled = config.programs.noctalia.enable or false;
  # writable Spotify copy so noctalia can swap xpui colors at runtime;
  # rendered by the spotify-colors user template in noctalia.nix
  spotifyDir = "${config.home.homeDirectory}/.local/share/spotify-noctalia";
  noctaliaColors = "${config.home.homeDirectory}/.config/spicetify/noctalia-colors.css";
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle
      playlistIcons
      historyShortcut
      keyboardShortcut
    ];

    theme = if noctaliaEnabled then spicePkgs.themes.comfy else spicePkgs.themes.text;
    colorScheme = if noctaliaEnabled then "custom" else "Nord";

    # static snapshot of a noctalia render — used as the seed/fallback
    # (~/.config/spicetify/Themes/Comfy/color.ini). spicetify-nix bakes
    # colors into the store, so live wallpaper-following would need an
    # imperative spicetify CLI setup on a writable spotify copy.
    customColorScheme = lib.mkIf noctaliaEnabled {
      text = "e9e1dc";
      subtext = "d2c4b8";
      main = "161310";
      main-elevated = "161310";
      main-transition = "100e0b";
      highlight = "1e1b18";
      highlight-elevated = "383431";
      sidebar = "161310";
      player = "161310";
      card = "161310";
      shadow = "161310";
      selected-row = "e9e1dc";
      button = "e5c099";
      button-active = "e5c099";
      button-disabled = "e5c099";
      tab-active = "161310";
      notification = "c7ca9f";
      notification-error = "ffb4ab";
      misc = "161310";
    };
  };

  # Copy the spiced Spotify out of the read-only store and point its
  # colors.css at the noctalia-rendered file; refreshed whenever the
  # package changes. ~/.local/bin/spotify shadows the store wrapper.
  home.activation.spotifyNoctalia = lib.mkIf noctaliaEnabled (lib.hm.dag.entryAfter ["writeBoundary"] ''
    pkg=${config.programs.spicetify.spicedSpotify}
    src="$pkg/share/spotify"
    dst="${spotifyDir}"
    colors="${noctaliaColors}"
    if [ "$(readlink "$dst/.spotify-src" 2>/dev/null)" != "$src" ]; then
      run rm -rf "$dst"
      run mkdir -p "$dst" "$(dirname "$colors")" "$HOME/.local/bin"
      run cp -r --no-preserve=ownership "$src/." "$dst/"
      run chmod -R u+w "$dst"
      [ -f "$colors" ] || run cp "$src/Apps/xpui/colors.css" "$colors"
      run ln -sfn "$colors" "$dst/Apps/xpui/colors.css"
      run ln -sfn "$src" "$dst/.spotify-src"
      run sh -c "sed \"s|$src|$dst|g\" \"$pkg/bin/spotify\" > \"$HOME/.local/bin/spotify\""
      run chmod +x "$HOME/.local/bin/spotify"
    fi
  '');
}
