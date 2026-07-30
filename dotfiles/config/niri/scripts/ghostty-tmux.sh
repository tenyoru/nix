#!/usr/bin/env bash
# Launch ghostty; if tmux has no running sessions, seed the default ones first.

if ! tmux has-session 2>/dev/null; then
    tmux new-session -d -s main -c ~
    tmux new-session -d -s nix -c ~/.nixos
    tmux new-session -d -s notes -c ~/notes
fi

exec ghostty -e tmux attach -t main
