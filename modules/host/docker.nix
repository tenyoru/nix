{hostConfig, ...}: {
  virtualisation.docker.enable = true;
  users.groups.docker.members = [hostConfig.username];
}
