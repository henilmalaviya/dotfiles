#!/bin/bash

# Check if wf-recorder is running
if pgrep -x "wf-recorder" > /dev/null; then
    # Output JSON for Waybar: red circle icon, class for CSS, and tooltip
    echo '{"text": "⏺", "class": "recording", "tooltip": "Recording screen..."}'
else
    # Output empty string so the module remains hidden
    echo '{"text": "", "class": "stopped"}'
fi
