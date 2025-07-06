#!/usr/bin/env bash

# Set your wifi interface explicitly if needed:
# IFACE="wlan0"
# Auto-detect:
IFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

RX_PREV=0
TX_PREV=0

# Read initial counters
if [ -f "/sys/class/net/$IFACE/statistics/rx_bytes" ]; then
    RX_PREV=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX_PREV=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
else
    echo "{\"text\": \" No interface\", \"tooltip\": \"\"}"
    exit
fi

sleep 1

RX_NOW=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_NOW=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

RX_RATE=$(( ($RX_NOW - $RX_PREV) ))
TX_RATE=$(( ($TX_NOW - $TX_PREV) ))

format_speed() {
    local SPEED=$1
    if [ $SPEED -lt 1024 ]; then
        echo "${SPEED}B/s"
    elif [ $SPEED -lt 1048576 ]; then
        echo "$(( SPEED / 1024 ))KB/s"
    else
        echo "$(( SPEED / 1048576 ))MB/s"
    fi
}

DL=$(format_speed $RX_RATE)
UL=$(format_speed $TX_RATE)

ICON_DL=""
ICON_UL=""

echo "{\"text\": \"<span foreground='#a6e3a1'>$ICON_DL $DL</span> <span foreground='#f5c2e7'>$ICON_UL $UL</span>\", \"tooltip\": \"Download: $DL\\nUpload: $UL\"}"