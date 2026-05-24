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

  xdg.configFile."nvim" = lib.mkIf useConfig {
    source = config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "nvim");
  };
  xdg.configFile."nvim/init.lua".enable = lib.mkIf useConfig (lib.mkForce false);
}
