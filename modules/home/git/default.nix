{ lib, hostConfig, ... }:
let
  defaultGit = {
    userName = "tenyoru";
    userEmail = "mail@tenyoru.io";
  };
  gitConfig = (hostConfig.git or {}) // defaultGit;
in
{
  programs.git = {
    enable = true;
    settings.user = {
      name = gitConfig.userName;
      email = gitConfig.userEmail;
    };
  };
}
