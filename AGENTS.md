# AGENTS.md

Operational guide for coding agents working in this repository.

## Scope and Purpose
- Repository type: NixOS flake with Home Manager integration.
- Primary goal: maintain reproducible host and user configuration.
- Current host layout is under `devices/` and discovered automatically.
- Prefer minimal, targeted edits that match existing module patterns.

## Repository Map
- `flake.nix`: flake inputs and top-level wiring.
- `outputs.nix`: builds `nixosConfigurations`, devShells, formatter.
- `lib/`: helper functions (`getHomeModules`, `getHostModules`, etc.).
- `modules/base.nix`: baseline module always imported.
- `modules/host/`: shared NixOS modules.
- `modules/home/`: shared Home Manager modules.
- `devices/<host>/`: host metadata and imports.
- `home/default.nix`: Home Manager integration entrypoint.
- `dotfiles/`: separate flake for out-of-store config symlinks.
- `secrets/`: SOPS-managed encrypted secrets.
- `justfile`: operational command entrypoints.

## Build, Lint, and Test Commands

### Daily Commands (preferred)
- `just build`: dry-run system build for default host (`core`).
- `just switch`: rebuild and activate configuration (state-changing; run only when asked).
- `just update`: update all flake inputs.
- `just update-input <input>`: update one flake input.
- `just update-check`: run `update` then `build`.

### Lint / Format
- `nix develop`: open dev shell with formatter/lint tools.
- `alejandra .`: canonical Nix formatter for this repo.
- `deadnix .`: detect dead Nix code.
- `statix check .`: Nix static analysis.

### Validation / Checks
- `just sops-check`: must pass before committing secret-related changes.
- `nix flake check`: run all flake checks (if defined by outputs/inputs).
- `nixos-rebuild build --flake .#core --sudo`: direct equivalent of `just build`.

### Running a Single "Test"

This repo does not define unit tests in the common `pytest/jest/go test` sense.
Use targeted Nix evaluations/builds as single-check equivalents:

- Build one host only:
  - `nix build .#nixosConfigurations.core.config.system.build.toplevel`
- Evaluate one option path quickly:
  - `nix eval .#nixosConfigurations.core.config.home-manager.useGlobalPkgs`
- Build one package attribute from current flake context:
  - `nix build .#formatter.x86_64-linux`

If a future module adds a dedicated test harness, document per-test invocation here.

## Code Style Guidelines (Nix)

### General Formatting
- Always format Nix files with `alejandra`.
- Use 2-space indentation (formatter-enforced).
- Keep lines readable; avoid dense nested expressions when a `let` improves clarity.
- Prefer trailing semicolons and standard Nix attrset style.

### Imports and Module Structure
- Module files should use canonical argset header style:
  - `{pkgs, ...}: { ... }`
  - `{mylib, ...}: { imports = ...; }`
- Keep argument sets minimal: include only what is used.
- Prefer `imports = mylib.getHomeModules [ ... ];` and `getHostModules` for shared modules.
- Add new reusable home modules under `modules/home/<name>.nix`.
- Add new reusable host modules under `modules/host/<name>.nix`.
- In host device files, keep imports as string module names when possible.

### Naming Conventions
- File/module names: lowercase kebab-case or simple lowercase (`python.nix`, `zen-browser.nix`).
- Nix attrs: camelCase (`hostConfig`, `homeModules`, `dotfilesCfg`).
- Lists of module names should be explicit string literals.
- Keep host name and directory intent clear (`devices/laptop-core`, host `name = "core"`).

### Types and Data Modeling
- Treat option defaults with `or` for optional attributes:
  - `hostConfig.dotfiles.enable or false`
  - `dotfilesCfg.configs or []`
- Use `builtins.listToAttrs` for converting lists to attrsets.
- Use explicit booleans for feature toggles.
- Keep package lists as `with pkgs; [ ... ]` in modules.

### Error Handling and Safety
- Prefer explicit failures over silent fallthrough in library helpers.
- Use clear `throw` messages in helper functions (see `lib/default.nix`).
- For activation scripts, guard file operations with existence checks.
- Do not commit decrypted secrets; run `just sops-check` before commit.
- Avoid destructive system operations unless user explicitly requests them.

### Comments and Documentation
- Add comments only for non-obvious logic.
- Keep comments short and operationally useful.
- Do not restate obvious Nix syntax.

### Package and Dependency Practices
- Put broadly reusable dev tools in dedicated modules (example: `modules/home/python.nix`).
- Keep host-specific extras in `devices/<host>/home.nix` inline module blocks only when truly host-bound.
- Prefer stable naming and avoid duplicate package declarations across modules.

## Workflow Expectations for Agents
- Read `CLAUDE.md` before large edits.
- Prefer `just` commands over raw long commands when equivalent exists.
- Do not run `just switch` unless the user asks to apply changes.
- For config-only edits, run at least `just build` (or explain why not run).
- When editing secrets, use `just sops` workflows and re-check encryption.
- Keep diffs narrow; avoid opportunistic refactors.

## Dotfiles Integration Rules
- Dotfiles path is expected at `~/.nixos/dotfiles/`.
- For modules that support dotfiles, preserve fallback behavior.
- When adding new dotfile-managed config, ensure both:
  - symlink path behavior,
  - dependency installation behavior.

## Git and Commit Conventions
- Repository VCS is git.
- Validate secrets before commit (`just sops-check` or `just commit`).
- Avoid amending commits unless explicitly requested.
- Do not revert unrelated local changes.

## Cursor / Copilot Rules
- Checked for Cursor rules in `.cursor/rules/` and `.cursorrules`: none found.
- Checked for Copilot instructions in `.github/copilot-instructions.md`: none found.
- If these files are added later, merge their guidance into this document.

## Quick Checklist Before Finishing a Change
- File placement follows architecture (`modules/`, `devices/`, `lib/`, `home/`).
- New module names are resolvable by `mylib.getHomeModules` / `getHostModules`.
- Formatting run with `alejandra` (or equivalent formatter output is clean).
- Build/eval command run for touched scope.
- Secrets remain encrypted.
- Final diff is minimal and understandable.
