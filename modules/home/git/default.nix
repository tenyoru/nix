{
  lib,
  hostConfig,
  ...
}: let
  gitConfig = hostConfig.git;
in {
  programs.git = {
    enable = true;
    settings.user = {
      name = gitConfig.userName;
      email = gitConfig.userEmail;
    };
  };
}
