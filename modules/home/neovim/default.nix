{
  pkgs,
  config,
  lib,
  mylib,
  hostConfig,
  ...
}: let
  useConfig = mylib.useDotfiles hostConfig;
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
  };

  # LSP servers and tools
  home.packages = with pkgs; [
    # Lua
    lua-language-server

    # Python
    basedpyright
    pyright
    ruff

    # Go
    gopls

    # TypeScript/JavaScript
    typescript-language-server

    # Rust (rust-analyzer provided by rustup)

    # C/C++
    clang-tools # clangd

    # Zig
    zls

    # Markdown
    markdown-oxide
    marksman

    # LaTeX
    texlab

    # Typst
    tinymist
  ];

  # Prevent HM from writing its own init.lua into the dotfiles-managed nvim dir
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  # Symlink to dotfiles when enabled (activation-time to avoid sandbox path check)
  home.activation.nvimConfig = lib.mkIf useConfig (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      ln -sfT "${mylib.dotfileConfig "nvim"}" "${config.xdg.configHome}/nvim"
    ''
  );
}
