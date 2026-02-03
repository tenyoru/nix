{ inputs, pkgs, config, lib, mylib, hostConfig, ... }:
let
  useConfig = mylib.useDotfiles hostConfig;
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
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

  # Symlink to dotfiles when enabled
  xdg.configFile."nvim" = lib.mkIf useConfig {
    source = config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "nvim");
  };
}
