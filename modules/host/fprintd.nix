{...}: {
  # Synaptics 06cb:00f9 — native libfprint support, no TOD driver needed.
  # Enabling fprintd auto-wires fingerprint auth into PAM (sudo, login, etc.).
  services.fprintd.enable = true;
}
