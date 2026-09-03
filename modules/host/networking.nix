{
  config,
  lib,
  ...
}: let
  networkingConfig =
    {
      hostName = "nixos";
      allowedTcpPorts = [8080];
      extraHosts = ''
        # 127.0.0.1 youtube.com
        # 127.0.0.1 music.youtube.com
        # 127.0.0.1 www.youtube.com
        # 127.0.0.1 api.youtube.com
      '';
      wireguardConfig = config.sops.secrets.wireguard_belgium_conf.path;
    }
    // (config._module.args.networking or {});
  wireguardSecret = config.sops.secrets.wireguard_private_key.path;
in {
  # WWAN modem (Quectel EM05-G): start ModemManager at boot so the
  # cellular connection auto-activates as a Wi-Fi fallback.
  systemd.services.ModemManager.wantedBy = ["multi-user.target"];

  # SIM PIN injected into the NM profile from SOPS at activation.
  sops.templates."sim-pin.env".content = "SIM_PIN=${config.sops.placeholder.sim_pin}";

  networking = {
    hostName = networkingConfig.hostName; # Define your hostname.
    networkmanager.enable = true;

    # Declarative mobile-broadband (WWAN) profile. Wi-Fi keeps priority
    # via its lower route metric; the modem is automatic fallback.
    networkmanager.ensureProfiles = {
      environmentFiles = [config.sops.templates."sim-pin.env".path];
      profiles.orange-be = {
        connection = {
          id = "orange-be";
          type = "gsm";
          autoconnect = true;
        };
        gsm = {
          apn = "internet";
          pin = "$SIM_PIN";
        };
        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    };

    firewall.allowedTCPPorts = networkingConfig.allowedTcpPorts;
    extraHosts = networkingConfig.extraHosts;
    wg-quick.interfaces.wg0 = {
      autostart = false;
      configFile = networkingConfig.wireguardConfig;
      privateKeyFile = wireguardSecret;
    };
  };

  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };
}
