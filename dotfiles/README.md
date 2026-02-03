# dotfiles

Plain configuration files managed via NixOS.

## Location

This directory must be at `~/.nixos/dotfiles/` for symlinks to work.

## Structure

```
dotfiles/
├── config/          # Plain config files (symlinked to ~/.config/)
│   ├── nvim/
│   ├── tmux/
│   ├── fish/
│   └── ...
├── bin/             # Scripts (added to PATH if dotfiles.bin = true)
└── flake.nix        # Exports homeModule for symlinks
```

## Usage

### 1. Define dotfiles list in host config

```nix
# hosts/your-host/default.nix
{
  username = "user";
  name = "hostname";
  platform = "x86_64-linux";

  # Modules that use dotfiles config instead of nix config
  dotfiles = [
    "tmux"
    "fish"
    "neovim"
  ];

  modules = { ... };
}
```

### 2. Import modules normally in home.nix

```nix
# hosts/your-host/home.nix
{ mylib, inputs, ... }: {
  imports = mylib.getHomeModules [
    "tmux"      # checks hostConfig.dotfiles automatically
    "fish"
    "neovim"
    # ...
  ];
}
```

### 3. For configs without main module, use dotfiles.homeModule

```nix
inputs.dotfiles.homeModule
{
  dotfiles = {
    enable = true;
    bin = true;
    configs = {
      btop = true;
      yazi = true;
      ghostty = true;
    };
  };
}
```

### 4. Rebuild

```bash
just switch
```

## How it works

Modules check `hostConfig.dotfiles`:
- If module name is in the list → symlink to `dotfiles/config/<name>`
- If not → use nix-managed config

Both always install dependencies (plugins, LSPs, etc.)

## Editing

Configs are symlinked, so edits apply immediately:

```bash
vim ~/.nixos/dotfiles/config/nvim/init.lua
# No rebuild needed
```

## Non-NixOS Systems

```bash
git clone <repo> ~/.nixos
ln -s ~/.nixos/dotfiles/config/nvim ~/.config/nvim
ln -s ~/.nixos/dotfiles/config/fish ~/.config/fish
```
