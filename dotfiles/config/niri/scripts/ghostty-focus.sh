#!/usr/bin/env bash
# Reuse the existing ghostty/tmux window as-is; launch attached to $LAUNCH_SESSION if none exists.
# If $SWITCH_TO is given, force an existing window over to that session too.

LAUNCH_SESSION="$1"
SWITCH_TO="$2"
SCRIPT_DIR="$(dirname "$0")"

WINDOW_ID=$(niri msg --json windows | jq -r '.[] | select(.app_id == "com.mitchellh.ghostty") | .id' | head -n 1)

if [ -n "$WINDOW_ID" ]; then
    if [ -n "$SWITCH_TO" ]; then
        PID=$(niri msg --json windows | jq -r ".[] | select(.id == $WINDOW_ID) | .pid")
        CLIENT_TTY=$(ps -o tty= --ppid "$PID" | tr -d ' ' | head -n 1)
        tmux switch-client -c "/dev/$CLIENT_TTY" -t "$SWITCH_TO"
    fi
    niri msg action focus-window --id "$WINDOW_ID"
else
    niri msg action spawn -- "$SCRIPT_DIR/ghostty-tmux.sh" "$LAUNCH_SESSION"
fi
