{
  config,
  mylib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    claude-code
    nodejs
  ];
  home.file.".claude/CLAUDE.md".source = ../../dotfiles/claude/CLAUDE.md;
  home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/dotfiles/claude/settings.json";
  home.file.".claude/skills/commit".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/dotfiles/claude/skills/commit";
  home.file.".claude/skills/skill-creator".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/dotfiles/claude/skills/skill-creator";
}
