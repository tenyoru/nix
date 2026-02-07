{ config, mylib, pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
    nodejs
  ];
  home.file.".claude/CLAUDE.md".source = ../../dotfiles/claude/CLAUDE.md;
  home.file.".claude/settings.json".source = ../../dotfiles/claude/settings.json;
}
