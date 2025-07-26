#!/bin/bash

current_workspace=$(hyprctl activeworkspace -j | jq .id)

# Launch rofi in background
rofi -show drun &
rofi_pid=$!

while sleep 0.1; do
    new_workspace=$(hyprctl activeworkspace -j | jq .id)
    if [ "$new_workspace" != "$current_workspace" ]; then
        kill $rofi_pid 2>/dev/null
        break
    fi
done