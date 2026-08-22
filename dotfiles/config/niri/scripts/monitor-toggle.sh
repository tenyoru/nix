#!/usr/bin/env bash
# Toggle the big monitor off/on, syncing noctalia caffeine mode so
# idle-lock doesn't kick in while working on just the laptop screen.
OUTPUT="DP-2"

if niri msg --json outputs | jq -e ".\"$OUTPUT\".logical" >/dev/null; then
    niri msg output "$OUTPUT" off
    noctalia msg caffeine-enable
else
    niri msg output "$OUTPUT" on
    noctalia msg caffeine-disable
fi
