# AGENTS.md

NixOS flake. The live tree is hardcoded to `/home/Tenyoru/.nixos` (`mylib.flakeDir`) — out-of-store dotfile symlinks depend on that path.

Prefer this file over `CLAUDE.md` if they conflict (`CLAUDE.md` is stale on overlays and `devices/<host>/home.nix`).

## Commands

```bash
just build                 # nixos-rebuild build --flake .#core --sudo  (compile, no activate)
just switch                # activate; never run unless asked
just HOST=pi5 build        # other host; default HOST is core
just update                # nix flake update
just update-input <name>
just sops                  # decrypt → edit → re-encrypt secrets/secrets.yaml
just sops-check            # required before every commit
nix fmt                    # alejandra (flake formatter)
```

- Do not enter `nix develop` from agents — `shellHook` is `exec fish`.
- Do not use `just commit` — it `git add .` with a generic message.
- After Nix edits: `nix fmt`, then targeted eval (or `just build`). Never `just switch` unless asked.

```bash
nix eval .#nixosConfigurations.core.config.system.stateVersion
nix build .#nixosConfigurations.core.config.system.build.toplevel
```

Flake attrs are `device.toml` `name`, not the directory: `devices/laptop-core` → `.#core`, `devices/pi5` → `.#pi5`.

## Wiring

`outputs.nix` scans `devices/*/`, reads `device.toml`, merges `lib/defaultArgs.nix`, `mylib.mkDevice`, then `nixosSystem`. `hostConfig` is `specialArgs` everywhere. `mergeConfig` strips `name` and `modules` — there is no `hostConfig.name`.

Enable with booleans in `[host]`, `[home]`, `[packages]`, `[stablePackages]`. Key = filename without `.nix` (`true` includes; `false`/omit skips). `mylib.findPath` accepts `name.nix` or `name/default.nix` and **throws** if missing.

Dotted package paths must be quoted or TOML nests them: `"pipewire.jack" = true`.

- `modules/host/` — NixOS; `modules/home/` — Home Manager
- Always imported: `modules/base.nix`. HM via `home/default.nix` (non-Pi only)
- New module: add the file, set `<name> = true` in the matching TOML section
- Delete an app: drop/false the TOML entry only, unless asked to delete the file
- Host-specific hardware stays in `devices/<host>/hardware.nix`
- `niri` is a **host** module (it also writes HM portal + config)
- `neovim` module → `dotfiles/config/nvim` (names differ)

## Dotfiles

`dotfiles/` is a nested flake (`inputs.dotfiles`). Home modules symlink with `mkOutOfStoreSymlink (mylib.dotfileConfig "app")` — edits apply without rebuild. `dotfiles.bin` puts `dotfiles/scripts/bin` on PATH. Only neovim/tmux/zellij gate on `mylib.useDotfiles`; most modules always symlink.

## Secrets

SOPS + Age. `secrets/secrets.yaml`, rules in `secrets/.sops.yaml`, per-host decls in `devices/<host>/secrets.nix`. Age key: `~/.config/sops/age/keys.txt`. Never commit decrypted YAML.

## Pi (`raspberrypi = true`)

Uses `nixos-raspberrypi.lib.nixosSystem`. Skips Home Manager, disko, and `base.nix` overlays. Must pass **full** `inputs` as `specialArgs` (a subset infinite-recurses). Do not add `inject-overlays` in `devices/pi5/hardware.nix`. Do not set `nixpkgs.follows` on `nixos-raspberrypi` or `noctalia`.

## Gotchas

- Non-Pi overlays in `base.nix`: `zig-overlay`, `millennium`, pinned `claude-code` (bump `version` + `hash` to update)
- `programs.fish.generateCompletions` must stay `false` (fish 4.8 broke HM)
- Laptop hostname is hardcoded `"nixos"` in `modules/host/networking.nix`
- No test suite (`lib/test.nix` is dead)
