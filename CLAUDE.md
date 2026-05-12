# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
just build                  # Dry-run rebuild (always run after edits)
just switch                 # Rebuild + activate (only when asked)
just update                 # Update all flake inputs
just update-input <name>    # Update one input
just sops                   # Edit secrets (decrypt → edit → re-encrypt)
just sops-check             # Verify secrets encrypted (required before commit)
just gc / just clean        # Garbage collect old generations
```

**Lint / format** (run inside `nix develop`):
```bash
alejandra .     # Canonical formatter (2-space, enforced)
deadnix .       # Detect dead code
statix check .  # Static analysis
```

**Targeted evaluation** (no full build):
```bash
nix build .#nixosConfigurations.core.config.system.build.toplevel
nix eval .#nixosConfigurations.core.config.home-manager.useGlobalPkgs
```

## Architecture

### Host Discovery and Wiring

`outputs.nix` auto-discovers hosts by scanning `devices/*/`. For each device:
1. Reads `device.toml` via `mylib.readToml` and merges with defaults from `lib/defaultArgs.nix`
2. Calls `mylib.mkDevice` → `getDeviceModules` to resolve enabled modules by feature flags
3. Builds `lib.nixosSystem` with `hostConfig` passed as `specialArgs` to all modules

The `hostConfig` attrset (merged TOML + defaults) is the single source of truth for per-host config — user name, state version, git identity, dotfiles flags, etc.

### Module System

**Two module tiers:**
- `modules/host/*.nix` — NixOS system-level (audio, networking, virtualisation, etc.)
- `modules/home/*.nix` — Home Manager user-level (neovim, fish, hyprland, etc.)

**Enabling modules:** Set a boolean in `device.toml` under `[host]` or `[home]`. The key must match the module filename (without `.nix`). `mylib.getHomeModules` / `getHostModules` resolve names to paths and handle both `name.nix` and `name/default.nix`.

**Injecting config into a module:**
```nix
# In device.toml processed form or outputs.nix:
{name = "audio"; config = {noiseCancellation = true;}}
# → module receives it via _module.args
```

**Adding a new module:** Create `modules/home/<name>.nix` or `modules/host/<name>.nix`, then add `<name> = true` to the relevant section of `device.toml`.

### Dotfiles Integration

Dotfiles live in `dotfiles/` as a separate flake (`inputs.dotfiles`). The dotfiles module uses `config.lib.file.mkOutOfStoreSymlink` for live, writable symlinks (not copied into the Nix store). In home modules:

```nix
useConfig = mylib.useDotfiles hostConfig;
xdg.configFile."app".source = lib.mkIf useConfig
  (config.lib.file.mkOutOfStoreSymlink (mylib.dotfileConfig "app"));
```

Always provide a non-dotfiles fallback (inline config) when adding dotfile-managed apps.

### Key Files

| File | Role |
|------|------|
| `outputs.nix` | Builds all `nixosConfigurations`; entry point for host wiring |
| `lib/default.nix` | `mylib`: module resolution, TOML reading, path helpers |
| `lib/defaultArgs.nix` | Baseline values merged into every `hostConfig` |
| `modules/base.nix` | Always-imported: overlays, unfree, flakes, core packages |
| `home/default.nix` | Home Manager entrypoint; converts dotfiles config and sets `$NIXOS_*` env vars |
| `devices/laptop-core/device.toml` | Current host config: feature flags, packages, dotfiles toggles |

### Secrets

SOPS + Age. Key at `secrets/.sops.yaml`. Always run `just sops-check` before committing. Never commit decrypted `secrets.yaml`. Host-specific secrets declared in `devices/<host>/secrets.nix`.

### Overlays (base.nix)

- `zig-overlay` — latest Zig toolchain
- `millennium` — Steam client mods
- `neovim-nightly-overlay` — injected directly as a package (not via overlay attr)

## Conventions

- Module args: include only what is used — `{pkgs, lib, hostConfig, mylib, ...}`
- Feature toggles: explicit booleans, never strings
- Package lists: `with pkgs; [ ... ]` style
- File names: lowercase kebab-case (`zen-browser.nix`, `cli-suggar.nix`)
- Nix attrs: camelCase (`hostConfig`, `homeModules`)
- Optional attribute access: use `or` — `hostConfig.dotfiles.enable or false`
- Use `let` bindings to break up dense nested expressions
- Use explicit `throw` with clear messages in `lib/` helpers (never silent fallthrough)
- Host-specific extras belong in `devices/<host>/home.nix` inline blocks, not shared modules
- Never run `just switch` unless the user asks to apply changes
- Keep diffs narrow; no opportunistic refactors

## Deleting Things

When asked to delete a module or app, **only remove the entry from `devices/laptop-core/device.toml`** unless explicitly told to also delete the module file.

## Git and Commit Conventions

- Run `just sops-check` (or `just commit`, which checks automatically) before every commit
- Do not amend commits unless explicitly asked
- Do not revert unrelated local changes

## Pre-Change Checklist

- File placement follows architecture (`modules/`, `devices/`, `lib/`, `home/`)
- New module names are resolvable by `mylib.getHomeModules` / `getHostModules`
- Formatted with `alejandra`
- `just build` (or targeted `nix eval`) run for touched scope
- When adding a dotfile-managed config: both symlink path and dependency installation are handled
- Secrets remain encrypted (`just sops-check`)
