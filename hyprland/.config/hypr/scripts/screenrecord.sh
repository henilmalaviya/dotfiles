#!/bin/bash

# Configuration
SAVE_DIR="$HOME/Videos/Recordings"
RECORD_AUDIO=false # Set to true to enable recording default audio source (mic)
RECORDER="wf-recorder"

# Ensure the save directory exists
mkdir -p "$SAVE_DIR"

# Generate filename with timestamp
FILENAME="recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
FILEPATH="$SAVE_DIR/$FILENAME"

# Send signal to Waybar to update the recording status indicator
update_waybar() {
    pkill -SIGRTMIN+8 waybar
}

# Helper function to copy the video to clipboard and notify the user
finalize_recording() {
    # Get the latest recording file in the save directory to ensure we copy the correct one
    LATEST_REC=$(ls -t "$SAVE_DIR"/recording_*.mp4 2>/dev/null | head -n1)
    
    if [ -n "$LATEST_REC" ]; then
        # Copy file path as URI list so browsers/apps can paste it as a file upload
        echo -n "file://$LATEST_REC" | wl-copy -t text/uri-list
        
        # Send a success notification with the filename
        notify-send -t 4000 \
            -a "Screen Recorder" \
            -i "video-x-generic" \
            "Recording Saved & Copied" \
            "Saved to: $(basename "$LATEST_REC")\nCopied directly to clipboard!"
    else
        notify-send -t 4000 -a "Screen Recorder" "Recording Stopped" "No recording file was found."
    fi
}

# Check if the recorder is already running
if pgrep -x "$RECORDER" > /dev/null; then
    # Stop recording gracefully by sending SIGINT (so the MP4 index is written correctly)
    killall -s SIGINT "$RECORDER"
    
    # Wait for the process to exit completely
    while pgrep -x "$RECORDER" > /dev/null; do
        sleep 0.1
    done
    
    update_waybar
    finalize_recording
    exit 0
fi

# Set up audio flag if enabled
AUDIO_FLAG=""
if [ "$RECORD_AUDIO" = true ]; then
    AUDIO_FLAG="-a"
fi

# Determine if we should record a region or fullscreen
if [ "$1" == "--region" ]; then
    # Run slurp to let the user select a region
    GEOMETRY=$(slurp)
    if [ -z "$GEOMETRY" ]; then
        # User cancelled region selection
        exit 0
    fi
    
    notify-send -t 2000 -a "Screen Recorder" "Recording Started" "Recording selected region..."
    # Start region recording in the background
    $RECORDER $AUDIO_FLAG -g "$GEOMETRY" -f "$FILEPATH" &
else
    notify-send -t 2000 -a "Screen Recorder" "Recording Started" "Recording fullscreen..."
    # Start fullscreen recording in the background
    $RECORDER $AUDIO_FLAG -f "$FILEPATH" &
fi

# Give wf-recorder a split second to start so it is registered in pgrep
sleep 0.2
update_waybar
