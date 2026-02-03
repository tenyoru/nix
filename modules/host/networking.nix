{ config, lib, ... }:
let
  networkingConfig = {
    hostName = "nixos";
    allowedTcpPorts = [ 8080 ];
    extraHosts = ''
      127.0.0.1 youtube.com
      127.0.0.1 music.youtube.com
      127.0.0.1 www.youtube.com
    '';
    wireguardConfig = "/etc/nixos/files/wireguard/frankfurt.conf";
  } // (config._module.args.networking or {});
  wireguardSecret = config.sops.secrets.wireguard_private_key.path;
in
{
  networking = {
    hostName = networkingConfig.hostName; # Define your hostname.
    networkmanager.enable = true;
    wireless.enable = true; # Explicitly disable wpa_supplicant when using NetworkManager

    firewall.allowedTCPPorts = networkingConfig.allowedTcpPorts;
    extraHosts = networkingConfig.extraHosts;
    wg-quick.interfaces.wg0 = {
      configFile = networkingConfig.wireguardConfig;
      privateKeyFile = wireguardSecret;
    };
  };
}
