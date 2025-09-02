#!/usr/bin/env bash

ICON=""
MAX_LENGTH=10

# Get all connected devices (MAC addresses)
CONNECTED_DEVICES=$(bluetoothctl devices Connected | awk '{print $2}' | grep -E '^([0-9A-F]{2}:){5}[0-9A-F]{2}$')

DISPLAY_TEXT="$ICON"

if [ -z "$CONNECTED_DEVICES" ]; then
    echo "{\"text\": \"$ICON\", \"tooltip\": \"No device connected\"}"
else
    DEVICES_ARRAY=()
    TOOLTIP_ARRAY=()
    for MAC in $CONNECTED_DEVICES; do
        INFO=$(bluetoothctl info "$MAC")
        NAME=$(echo "$INFO" | grep "Name" | awk -F ': ' '{print $2}')
        BATTERY=$(echo "$INFO" | grep "Battery Percentage" | grep -oP '\(\K[0-9]+')
        [ ${#NAME} -gt $MAX_LENGTH ] && SHORT_NAME="${NAME:0:$MAX_LENGTH}…" || SHORT_NAME="$NAME"
        if [ -n "$BATTERY" ]; then
            DEVICES_ARRAY+=("$SHORT_NAME (${BATTERY}%)")
            TOOLTIP_ARRAY+=("$NAME (${BATTERY}%)")
        else
            DEVICES_ARRAY+=("$SHORT_NAME")
            TOOLTIP_ARRAY+=("$NAME")
        fi
    done

    FINAL_TEXT="$ICON  $(printf '%s, ' "${DEVICES_ARRAY[@]}")"
    FINAL_TEXT="${FINAL_TEXT%, }"  # Remove trailing comma and space

    FINAL_TOOLTIP="$(printf '%s\\n' "${TOOLTIP_ARRAY[@]}")"
    FINAL_TOOLTIP="${FINAL_TOOLTIP%\\n}"  # Remove trailing newline for cleaner output

    echo "{\"text\": \"$FINAL_TEXT\", \"tooltip\": \"$FINAL_TOOLTIP\"}"

fi
