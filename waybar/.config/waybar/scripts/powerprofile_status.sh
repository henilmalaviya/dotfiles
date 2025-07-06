#!/usr/bin/env bash

ICON=""

PROFILE=$(powerprofilesctl get)

case "$PROFILE" in
    power-saver)
        NAME="Saver"
        COLOR="#a6e3a1"
        ;;
    balanced)
        NAME="Balanced"
        COLOR="#f5c2e7"
        ;;
    performance)
        NAME="Perf"
        COLOR="#f38ba8"
        ;;
    *)
        NAME="Unknown"
        COLOR="#ffffff"
        ;;
esac

echo "{\"text\": \"<span foreground='$COLOR' size='10000'>$ICON </span><span foreground='$COLOR'>$NAME</span>\", \"tooltip\": \"Current power profile: $NAME\"}" 
