#!/usr/bin/env bash

state_file="/tmp/waybar_caffeine_state"

if [[ -f "$state_file" ]]; then
    # Disable caffeine (restart hypridle)
    hypridle &
    rm "$state_file"
else
    # Enable caffeine (kill hypridle)
    pkill hypridle
    touch "$state_file"
fi