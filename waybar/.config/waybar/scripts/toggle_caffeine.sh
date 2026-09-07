#!/usr/bin/env bash

state_file="/tmp/waybar_caffeine_state"

if [[ -f "$state_file" ]]; then
    # Disable caffeine (restart hypridle service)
    systemctl --user start dotfiles-hypridle.service
    rm "$state_file"
else
    # Enable caffeine (stop hypridle service)
    systemctl --user stop dotfiles-hypridle.service
    pkill -9 hypridle 2>/dev/null
    touch "$state_file"
fi