#!/bin/sh

# 1. Battery
if [ -d /sys/class/power_supply/BAT0 ]; then
    status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
    capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
    if [ "$status" = "Charging" ]; then
        bat_icon="⚡"
    else
        bat_icon="🔋"
    fi
    bat_str="${bat_icon} ${capacity}%"
else
    bat_str=""
fi

# 2. Volume
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
if [ -n "$vol_raw" ]; then
    if echo "$vol_raw" | grep -q "MUTED"; then
        vol_str="🔇 Muted"
    else
        vol_val=$(echo "$vol_raw" | awk '{print int($2 * 100)}')
        vol_str="🔊 ${vol_val}%"
    fi
else
    vol_str=""
fi

# 3. Brightness
if command -v brightnessctl >/dev/null 2>&1; then
    bright_raw=$(brightnessctl -m 2>/dev/null)
    if [ -n "$bright_raw" ]; then
        bright_val=$(echo "$bright_raw" | cut -d, -f4)
        bright_str="☀️ ${bright_val}"
    else
        bright_str=""
    fi
else
    bright_str=""
fi

# Combine indicators
res=""
if [ -n "$bat_str" ]; then
    res="<span foreground='#a6e3a1'>$bat_str</span>"
fi

if [ -n "$vol_str" ]; then
    if [ -n "$res" ]; then
        res="$res  |  <span foreground='#89b4fa'>$vol_str</span>"
    else
        res="<span foreground='#89b4fa'>$vol_str</span>"
    fi
fi

if [ -n "$bright_str" ]; then
    if [ -n "$res" ]; then
        res="$res  |  <span foreground='#f9e2af'>$bright_str</span>"
    else
        res="<span foreground='#f9e2af'>$bright_str</span>"
    fi
fi

echo "$res"
