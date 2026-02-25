{
  config,
  hostConfig,
  ...
}: let
  username = hostConfig.username;
  secretsPath = "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
in {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = secretsPath;

    secrets = {
      wireguard_private_key = {
        key = "wireguard_private_key";
        owner = username;
        mode = "0400";
      };
      wireguard_amsterdam_conf = {
        key = "wireguard_amsterdam_conf";
        owner = username;
      };
      wireguard_frankfurt_conf = {
        key = "wireguard_frankfurt_conf";
        owner = username;
      };
      sudo_password = {
        key = "sudo_password";
        owner = username;
        mode = "0400";
      };
      context7_api_key = {
        key = "context7_api_key";
        owner = username;
        mode = "0400";
      };
    };
  };
}
