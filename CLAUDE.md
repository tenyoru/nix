# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS flake-based configuration using a modular architecture with home-manager integration. The configuration supports multiple hosts (currently: `laptop-core`) and uses jujutsu for version control.

## Build and Development Commands

### System Management
- `just switch` - Rebuild and switch to new NixOS configuration (default host: core)
- `just build` - Build configuration without switching (dry-run)
- `just update` - Update all flake inputs and show changes
- `just update-input INPUT` - Update a specific flake input
- `just update-switch` - Update inputs and switch in one command
- `just gc` - Garbage collect old store paths
- `just clean` - Remove old generations and garbage collect

### Version Control (Jujutsu)
- `just sync` - Switch, commit, and push changes
- `just commit` - Commit changes (after sops-check validation)
- `just push` - Push to remote

### Secrets Management (SOPS)
- `just sops` - Edit secrets (decrypt, edit, re-encrypt)
- `just sops-show` - Show decrypted secrets
- `just sops-check` - Verify secrets are encrypted before commit

### Development
- `nix develop` - Enter development shell with formatting and linting tools (alejandra, deadnix, statix)

## Architecture

### Flake Structure

- **flake.nix** - Minimal entry point, delegates to `outputs.nix`
- **outputs.nix** - Main flake logic: discovers hosts, constructs NixOS configurations
- **lib/** - Custom library functions for module discovery and dotfile management
- **devices/** - Per-host configurations (auto-discovered as directories)
- **modules/** - Shared NixOS and home-manager modules
  - **modules/host/** - System-level modules
  - **modules/home/** - User-level modules (home-manager)
- **modules/base.nix** - Base module always included for all hosts
- **dotfiles/** - Plain configuration files (separate flake, symlinked to ~/.config/)
- **home/** - Home-manager base configuration
- **secrets/** - SOPS-encrypted secrets

### Host Configuration Pattern

Each host in `devices/<hostname>/` follows this structure:

```nix
# default.nix - Host metadata and module selection
{
  username = "username";
  name = "hostname";
  platform = "x86_64-linux";
  dotfiles = { enable = true; bin = true; };
  modules = {
    host = [ /* system modules */ ];
    home = [ /* home-manager modules */ ];
  };
}

# host.nix - System modules list
{ mylib, ... }: {
  imports = mylib.getHostModules [ "fonts" "locale" "audio" /* ... */ ];
}

# home.nix - Home-manager modules list
{ mylib, ... }: {
  imports = mylib.getHomeModules [ "neovim" "tmux" "fish" /* ... */ ];
}

# configuration.nix - Host-specific overrides
# hardware.nix - Hardware-specific configuration
# secrets.nix - SOPS secrets configuration
```

### Module Discovery System

The custom library (`lib/default.nix`) provides:

- **mylib.getHostModules** - Resolve modules from `modules/host/`
- **mylib.getHomeModules** - Resolve modules from `modules/home/`
- **mylib.scanPaths** - Auto-discover .nix files in a directory
- **mylib.dotfile** - Get absolute path to dotfile for out-of-store symlinks
- **mylib.mkDotfile** - Create dotfile symlink with default fallback

Modules can be referenced by string name (e.g., `"neovim"` resolves to `modules/home/neovim.nix` or `modules/home/neovim/`).

### Dotfiles System

Dotfiles are managed in a separate flake (`dotfiles/`) and symlinked to `~/.config/`. This allows editing configs without rebuilding NixOS. The dotfiles directory structure:

- `config/` - Configuration files (symlinked to ~/.config/)
- `bin/` - Scripts (added to PATH if `dotfiles.bin = true`)
- `claude/` - Claude-specific configurations

Modules check if dotfiles are enabled for a specific config and either:
1. Symlink to `dotfiles/config/<name>` (if enabled)
2. Use nix-managed config (if not in dotfiles list)

Both approaches always install dependencies (plugins, LSPs, etc.).

## Key Flake Inputs

- **nixpkgs** - Follows unstable channel
- **master**, **unstable**, **stable** - Different nixpkgs channels
- **home-manager** - User environment management
- **disko** - Disk partitioning
- **sops-nix** - Secrets management
- **hyprland** + **hyprland-plugins** - Wayland compositor
- **anyrun** - Application launcher
- **neovim-nightly-overlay** - Neovim nightly builds

## Important Conventions

1. **Version Control**: This repository uses **jujutsu** for VCS (not git directly). Use `jj` commands or the justfile recipes.

2. **Secrets**: Always verify secrets are encrypted before committing with `just sops-check`. The commit command includes this check automatically.

3. **Formatting**: Run `alejandra .` to format Nix files. The devShell includes pre-commit hooks.

4. **Host Names**: The justfile defaults to HOST="core". Change this for different hosts or use `just switch --set HOST <name>`.

5. **Dotfiles Location**: The dotfiles directory MUST be at `~/.nixos/dotfiles/` for symlinks to work correctly (hardcoded in `lib/defaultArgs.nix`).

6. **Module References**: When adding modules, use string names that match filenames in `modules/host/` or `modules/home/` directories.
