#!/usr/bin/env bash
# Script to focus a window by app-id, or launch it if it doesn't exist

APP_ID="$1"
LAUNCH_CMD="$2"

# Get all windows and find the one matching the app-id
WINDOW_ID=$(niri msg --json windows | jq -r ".[] | select(.app_id == \"$APP_ID\") | .id" | head -n 1)

if [ -n "$WINDOW_ID" ]; then
    # Window exists, focus it
    niri msg action focus-window --id "$WINDOW_ID"
else
    # Window doesn't exist, launch the app
    niri msg action spawn -- $LAUNCH_CMD
fi
