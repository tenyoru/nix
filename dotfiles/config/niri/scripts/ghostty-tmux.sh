#!/usr/bin/env bash
# Launch ghostty; if tmux has no running sessions, seed the default ones first.

if ! tmux has-session 2>/dev/null; then
    tmux new-session -d -s main -c ~

    tmux new-session -d -s nix -c ~/.nixos -n claude
    tmux send-keys -t nix:claude 'claude --remote-control nix' Enter
    tmux new-window -t nix -c ~/.nixos -n shell

    tmux new-session -d -s notes -c ~/notes -n claude
    tmux send-keys -t notes:claude 'claude --remote-control notes' Enter
    tmux new-window -t notes -c ~/notes -n shell
fi

exec ghostty -e tmux attach -t main
