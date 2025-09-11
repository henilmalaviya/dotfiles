#!/bin/sh
MONITOR="eDP-1"
STATE=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MONITOR\").dpmsStatus")
if [ "$STATE" = "true" ]; then
    hyprctl dispatch dpms off $MONITOR
else
    hyprctl dispatch dpms on $MONITOR
fi
