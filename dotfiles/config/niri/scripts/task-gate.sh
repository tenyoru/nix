#!/usr/bin/env bash
# Blocks until a task description (>10 chars) is entered; logs it with a timestamp.
LOG="$HOME/.local/share/tasks.log"
mkdir -p "$(dirname "$LOG")"

task=""
while [ "${#task}" -le 10 ]; do
    task=$(fuzzel --dmenu --prompt-only "Задача (>10 символов): ")
done

printf '%s\t%s\n' "$(date '+%F %T')" "$task" >>"$LOG"
