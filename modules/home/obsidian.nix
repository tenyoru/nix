{
  pkgs,
  config,
  lib,
  ...
}: let
in {
  # Install obsidian and task script
  home.packages = with pkgs; [
    obsidian
  ];

  # Create Obsidian vault directory structure
  home.activation.createObsidianVault = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/notes/"99 - System/Tasks"
    $DRY_RUN_CMD mkdir -p $HOME/notes/.obsidian
  '';

  # Set environment variable for vault location
  home.sessionVariables = {
    OBSIDIAN_VAULT = "$HOME/notes";
    OBSIDIAN_TASKS = "$HOME/notes/99 - System/Tasks";
  };
}
