#!/usr/bin/env bash

echo "Installing openssh..."
nix-env -iA nixpkgs.openssh

echo "Creating SSH directory..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "Generating host keys..."
~/.nix-profile/bin/ssh-keygen -t rsa -f ~/.ssh/ssh_host_rsa_key -N ""
~/.nix-profile/bin/ssh-keygen -t ed25519 -f ~/.ssh/ssh_host_ed25519_key -N ""

echo "Creating sshd config..."
cat > ~/.ssh/sshd_config << 'EOF'
Port 8022
HostKey ~/.ssh/ssh_host_rsa_key
HostKey ~/.ssh/ssh_host_ed25519_key
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile ~/.ssh/authorized_keys
EOF

echo "Starting sshd..."
~/.nix-profile/bin/sshd -f ~/.ssh/sshd_config

echo ""
echo "SSH daemon started on port 8022"
echo "Connect from another device with:"
echo "ssh -p 8022 nix-on-droid@<phone-ip>"
