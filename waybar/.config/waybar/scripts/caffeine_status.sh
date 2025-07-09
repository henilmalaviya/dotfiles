#!/usr/bin/env bash

state_file="/tmp/waybar_caffeine_state"

if [[ -f "$state_file" ]]; then
    echo '{"text":"󰅶","tooltip":"Caffeine: ON"}'
else
    echo '{"text":"󰾰","tooltip":"Caffeine: OFF"}'
fi
