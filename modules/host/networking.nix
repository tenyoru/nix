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
        127.0.0.1 youtube.com
        127.0.0.1 music.youtube.com
        127.0.0.1 www.youtube.com
        127.0.0.1 api.youtube.com
      '';
      wireguardConfig = config.sops.secrets.wireguard_belgium_conf.path;
    }
    // (config._module.args.networking or {});
  wireguardSecret = config.sops.secrets.wireguard_private_key.path;
in {
  networking = {
    hostName = networkingConfig.hostName; # Define your hostname.
    networkmanager.enable = true;

    firewall.allowedTCPPorts = networkingConfig.allowedTcpPorts;
    extraHosts = networkingConfig.extraHosts;
    wg-quick.interfaces.wg0 = {
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
