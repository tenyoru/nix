{ lib, config, hostConfig, pkgs, ... }:
let
  defaultConfig = {
    userName = "tenyoru";
    userEmail = "mail@tenyoru.io";
  };
  userConfig = (hostConfig.git or {}) // defaultConfig;

  # Options:
  # vcs = "git" - use git only
  # vcs = "jujutsu" (default) - use jujutsu with git backend
  # vcs = "jujutsu-only" - use jujutsu without git (experimental, may break remote operations)
  vcsMode = hostConfig.vcs or "jujutsu";
  useJujutsu = vcsMode == "jujutsu" || vcsMode == "jujutsu-only";
  useGit = vcsMode == "git" || vcsMode == "jujutsu";
in
{
  programs.jujutsu = {
    enable = useJujutsu;
    settings = {
      user = {
        name = userConfig.userName;
        email = userConfig.userEmail;
      };
      ui = {
        default-command = "log";
        pager = "less -FRX";
      };
      git = {
        auto-local-branch = true;
      };
    };
  };

  # Git is optional - disable only if vcs = "jujutsu-only"
  # Note: Some jujutsu operations may fail without git backend
  programs.git = lib.mkIf useGit {
    enable = true;
    userName = userConfig.userName;
    userEmail = userConfig.userEmail;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
