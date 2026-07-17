{
  # Neither power-profiles-daemon nor tuned — both hard-conflict
  # with services.tlp (already enabled in services.nix for battery
  # thresholds). upower alone is what drives the bar's battery icon.
  services.upower.enable = true;
}
