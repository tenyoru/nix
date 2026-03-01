{mylib, ...}: {
  imports = mylib.getHomeModules [
    "git"
    "neovim"
    "fish"
    "tmux"
  ];
}
