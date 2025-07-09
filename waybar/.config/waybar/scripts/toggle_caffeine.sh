#!/usr/bin/env bash

state_file="/tmp/waybar_caffeine_state"

if [[ -f "$state_file" ]]; then
    # Disable caffeine (reenable hypridle)
    pkill -SIGCONT hypridle
    rm "$state_file"
else
    # Enable caffeine (pause hypridle)
    pkill -SIGSTOP hypridle
    touch "$state_file"
fi
