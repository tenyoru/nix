{
  lib,
  hostConfig,
  pkgs,
  ...
}: let
  gitConfig = hostConfig.git;
in {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = gitConfig.userName;
        email = gitConfig.userEmail;
      };
      ui = {
        default-command = "log";
        pager = "less -FRX";
      };
      remotes.origin.auto-track-bookmarks = "*";
    };
  };
}
