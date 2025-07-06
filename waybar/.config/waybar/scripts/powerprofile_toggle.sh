#!/usr/bin/env bash

CURRENT=$(powerprofilesctl get)

if [ "$CURRENT" = "power-saver" ]; then
    powerprofilesctl set balanced
elif [ "$CURRENT" = "balanced" ]; then
    powerprofilesctl set performance
else
    powerprofilesctl set power-saver
fi
