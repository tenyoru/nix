{mylib, ...}: {
  imports = mylib.getHomeModules [
    "neovim"
    "fish"
    "tmux"
  ];
}
