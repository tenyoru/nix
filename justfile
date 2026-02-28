# Default host
HOST := "core"

default:
  just --list

# Rebuild and switch to new configuration
switch:
    @printf '\033[1;33mRebuilding NixOS...\033[0m\n'
    nixos-rebuild switch --flake .#{{HOST}} --sudo
    @printf '\033[0;32m✓ System rebuilt successfully\033[0m\n'

# Build without switching (dry-run)
build:
    @printf '\033[1;33mBuilding NixOS (dry-run)...\033[0m\n'
    nixos-rebuild build --flake .#{{HOST}} --sudo
    @printf '\033[0;32m✓ Build successful\033[0m\n'

# Update all flake inputs
update:
    @printf '\033[0;34m=== NixOS Flake Update ===\033[0m\n'
    @printf '\033[1;33mUpdating all flake inputs...\033[0m\n'
    nix flake update
    @if git diff flake.lock | grep -q "^+.*narHash"; then \
        printf '\033[0;32mChanges detected in flake.lock\033[0m\n'; \
        git diff flake.lock | grep "^\+.*url\|^\-.*url" || true; \
    else \
        printf '\033[1;33mNo changes in flake.lock\033[0m\n'; \
    fi

# Update a specific flake input
update-input INPUT:
    @printf '\033[0;34m=== NixOS Flake Update ===\033[0m\n'
    @printf '\033[1;33mUpdating input: {{INPUT}}\033[0m\n'
    nix flake lock --update-input {{INPUT}}
    @if git diff flake.lock | grep -q "^+.*narHash"; then \
        printf '\033[0;32mChanges detected in flake.lock\033[0m\n'; \
        git diff flake.lock | grep "^\+.*url\|^\-.*url" || true; \
    else \
        printf '\033[1;33mNo changes in flake.lock\033[0m\n'; \
    fi

# Update inputs and build (no switch)
update-check: update build

# Update inputs and switch
update-switch: update switch

# Switch, commit, and push
sync: switch commit push
    @printf '\033[0;32m✓ Sync complete\033[0m\n'

# Commit all changes (checks secrets first)
commit: sops-check
    @printf '\033[1;33mCommitting changes...\033[0m\n'
    git add .
    git commit -m "feat: update flake $(date '+%Y-%m-%d %H:%M:%S')" || echo "Nothing to commit"


# Push to remote
push:
    @printf '\033[1;33mPushing to remote...\033[0m\n'
    git push

# Garbage collect old store paths
gc:
    @printf '\033[1;33mRunning garbage collection...\033[0m\n'
    sudo nix-collect-garbage -d
    @printf '\033[0;32m✓ Garbage collection complete\033[0m\n'

# Delete old generations and garbage collect
clean:
    @printf '\033[1;33mRemoving old generations...\033[0m\n'
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage -d
    @printf '\033[0;32m✓ Cleanup complete\033[0m\n'

# Edit secrets (decrypt, edit, re-encrypt)
sops:
    cd secrets && nix shell nixpkgs#sops -c sops secrets.yaml

# Show decrypted secrets
sops-show:
    cd secrets && nix shell nixpkgs#sops -c sops -d secrets.yaml

# Decrypt secrets in place
sops-decrypt:
    cd secrets && nix shell nixpkgs#sops -c sops -d -i secrets.yaml

# Encrypt secrets in place
sops-encrypt:
    cd secrets && nix shell nixpkgs#sops -c sops -e -i secrets.yaml

# Check if secrets are encrypted (safe to commit)
sops-check:
    @if grep -q "^sops:" secrets/secrets.yaml && grep -q "ENC\[" secrets/secrets.yaml; then \
        printf '\033[0;32m✓ Secrets are encrypted\033[0m\n'; \
    else \
        printf '\033[0;31m✗ Secrets are NOT encrypted! Run: just sops-encrypt\033[0m\n'; \
        exit 1; \
    fi
