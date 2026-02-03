{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    ripgrep
    fzf #also need for neovim
    fd #find
    bat #cat
    zoxide #cd
    tldr #man
    eza #ls
    dust #du
    # yazi
    jq
    inputs.cclock.packages.${pkgs.stdenv.hostPlatform.system}.cclock
  ];
}
