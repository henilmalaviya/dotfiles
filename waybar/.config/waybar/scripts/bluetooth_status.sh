#!/usr/bin/env bash

ICON=""

CONNECTED_DEVICE=$(bluetoothctl info | grep "Name" | awk -F ': ' '{print $2}')

BATTERY_RAW=$(bluetoothctl info | grep "Battery Percentage" | grep -oP '\(\K[0-9]+')

if [ -n "$BATTERY_RAW" ]; then
    BATTERY_TEXT="${BATTERY_RAW}%"
else
    BATTERY_TEXT=""
fi

if [ -z "$CONNECTED_DEVICE" ]; then
    echo "{\"text\": \"$ICON\", \"tooltip\": \"No device connected\"}"
else
    MAX_LENGTH=10
    if [ ${#CONNECTED_DEVICE} -gt $MAX_LENGTH ]; then
        SHORT_NAME="${CONNECTED_DEVICE:0:$MAX_LENGTH}…"
    else
        SHORT_NAME="$CONNECTED_DEVICE"
    fi
    echo "{\"text\": \"$ICON  $SHORT_NAME ($BATTERY_TEXT)\", \"tooltip\": \"Connected to $CONNECTED_DEVICE\"}"
fi