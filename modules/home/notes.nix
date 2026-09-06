{
  config,
  pkgs,
  ...
}: let
  vault = "${config.home.homeDirectory}/notes";
  taskDir = "${config.home.homeDirectory}/.local/share/notes-task";
in {
  home.packages = with pkgs; [
    timewarrior
    markdown-oxide
    git-crypt
    mermaid-cli
    chafa
  ];

  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
  };

  home.sessionVariables = {
    NOTE_VAULT = vault;
    TIMEWARRIORDB = "${taskDir}/timewarrior";
  };

  systemd.user.services.notes-sync = {
    Unit.Description = "Sync notes vault git repo";
    Service = {
      Type = "oneshot";
      WorkingDirectory = vault;
      ExecStart = pkgs.writeShellScript "notes-sync" ''
        mkdir -p ${taskDir}
        ${pkgs.taskwarrior3}/bin/task export > ${taskDir}/tasks.json
        ${pkgs.just}/bin/just sync
      '';
    };
  };

  systemd.user.timers.notes-sync = {
    Unit.Description = "Hourly notes vault sync";
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
}
