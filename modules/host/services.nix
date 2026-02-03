{ config, hostConfig, pkgs, ... }:
let
  username = hostConfig.username;
in
{
  services = {
    nextdns = {
      enable = true;
      arguments = [ "-config" "abcdef" "-cache-size" "10MB" ];
    };
    udisks2.enable = true;
    blueman.enable = true;
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    postgresql.enable = true;
    libinput.enable = true; # Enable touchpad support
    udev.packages = with pkgs; [
      usbutils
      platformio-core
      stlink
      openocd
    ];
    logind.settings = {
      Login = {
        HandlePowerKey = "ignore";
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };

    mpd = {
      enable = true;
      user = username;
      settings = {
        music_directory = "/home/${username}/music";
        audio_output = [
          {
            type = "pipewire";
            name = "My PipeWire Output";
          }
        ];
      };
    };
  };

  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${username}.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
