#!/usr/bin/env bash

# Get the floating state of the active window
is_floating=$(hyprctl activewindow -j | jq '.floating')

# If the window is not floating, make it float
if [ "$is_floating" == "false" ]; then
    hyprctl dispatch togglefloating
fi

# Pin the window
hyprctl dispatch pin