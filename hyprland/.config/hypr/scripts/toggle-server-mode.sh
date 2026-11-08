#!/usr/bin/env bash
# ==============================================================================
# toggle-server-mode.sh
# Toggle laptop into a reliable, low-power "Server Mode" and back.
# Designed for overnight background tasks (rsync, t3code agents, builds, etc.)
# ==============================================================================

STATE_FILE="/tmp/server_mode_state"
INHIBIT_PID_FILE="/tmp/server_mode_inhibit.pid"
PREV_PROFILE_FILE="/tmp/server_mode_prev_profile"
PREV_BT_FILE="/tmp/server_mode_prev_bt"
PREV_TURBO_FILE="/tmp/server_mode_prev_turbo"
PREV_DIRTY_FILE="/tmp/server_mode_prev_dirty"
LOCK_DIR="/tmp/server_mode_mutex"

# Configuration options:
# 1. Keep Wi-Fi & network at 100% full unthrottled performance by keeping CPU
#    on balanced profile (power-saver can throttle SSH decryption & PCIe throughput).
ENABLE_POWERSAVER_PROFILE="${ENABLE_POWERSAVER_PROFILE:-false}"

# 2. Automatically lock screen via hyprlock when entering Server Mode.
LOCK_ON_ACTIVATE="${LOCK_ON_ACTIVATE:-false}"

# 3. Soft-block Bluetooth ONLY if no Bluetooth device is currently connected.
OPTIMIZE_BLUETOOTH="${OPTIMIZE_BLUETOOTH:-true}"

is_active() {
    [ -f "$STATE_FILE" ]
}

turn_display_off() {
    # Hyprland Lua DPMS dispatcher with explicit action table (strictly idempotent)
    hyprctl dispatch 'hl.dsp.dpms({ action = "off" })' 2>/dev/null || true
}

turn_display_on() {
    # Hyprland Lua DPMS dispatcher with explicit action table (strictly idempotent)
    hyprctl dispatch 'hl.dsp.dpms({ action = "on" })' 2>/dev/null || true
    # Safety: ensure brightness is non-zero
    if command -v brightnessctl &>/dev/null; then
        local curr_br
        curr_br=$(brightnessctl get 2>/dev/null || echo 1)
        if [ "$curr_br" -eq 0 ]; then
            brightnessctl set 80% 2>/dev/null || true
        fi
    fi
}

activate_server_mode() {
    # Mark state immediately
    touch "$STATE_FILE"

    # 1. Power Profile (optional; default false to keep Wi-Fi and rsync unthrottled)
    if [ "$ENABLE_POWERSAVER_PROFILE" = "true" ] && command -v powerprofilesctl &>/dev/null; then
        current_profile=$(powerprofilesctl get 2>/dev/null)
        echo "$current_profile" > "$PREV_PROFILE_FILE"
        powerprofilesctl set power-saver 2>/dev/null
        pkill -SIGRTMIN+9 waybar 2>/dev/null || true
    fi

    # 2. Intel Turbo Boost cap (prevents voltage spikes above base clock, if writable)
    if [ -w /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        cat /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null > "$PREV_TURBO_FILE"
        echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null || true
    fi

    # 3. Batch disk writeback timers (keeps NVMe in APST low-power state, if writable)
    if [ -w /proc/sys/vm/dirty_writeback_centisecs ]; then
        cat /proc/sys/vm/dirty_writeback_centisecs 2>/dev/null > "$PREV_DIRTY_FILE"
        echo 1500 > /proc/sys/vm/dirty_writeback_centisecs 2>/dev/null || true
    fi

    # 4. Bluetooth: only block if no active device is connected
    if [ "$OPTIMIZE_BLUETOOTH" = "true" ] && command -v rfkill &>/dev/null; then
        has_connected_bt=false
        if command -v bluetoothctl &>/dev/null; then
            if [ -n "$(bluetoothctl devices Connected 2>/dev/null)" ]; then
                has_connected_bt=true
            fi
        fi

        if [ "$has_connected_bt" = "false" ]; then
            if rfkill list bluetooth 2>/dev/null | grep -q "Soft blocked: no"; then
                echo "unblocked" > "$PREV_BT_FILE"
                rfkill block bluetooth 2>/dev/null || true
            else
                echo "blocked" > "$PREV_BT_FILE"
            fi
        fi
    fi

    # 5. Pause media players so audio DAC/bus can sleep
    if command -v playerctl &>/dev/null; then
        playerctl -a pause 2>/dev/null || true
    fi

    # 6. Inhibit systemd suspend/sleep on lid-close and idle (spawn in background)
    systemd-inhibit --what=handle-lid-switch:idle:sleep \
                    --who="ServerMode" \
                    --why="Laptop server mode active for background tasks" \
                    sleep infinity </dev/null &>/dev/null &
    INHIBIT_PID=$!
    echo "$INHIBIT_PID" > "$INHIBIT_PID_FILE"

    # 7. Notify user
    notify-send -u normal -t 2500 -a "Server Mode" "Server Mode ACTIVATED" \
        "• Lid-close sleep inhibited\n• Wi-Fi unthrottled (full performance)\n• Turning display off..." 2>/dev/null || true

    sleep 0.3

    # 8. Optional lockscreen
    if [ "$LOCK_ON_ACTIVATE" = "true" ]; then
        if command -v hyprlock &>/dev/null && ! pidof hyprlock &>/dev/null; then
            hyprlock </dev/null &>/dev/null &
            sleep 0.2
        fi
    fi

    # 9. Turn off displays reliably
    turn_display_off
}

deactivate_server_mode() {
    # 1. Turn on all displays immediately (guaranteed ON, never toggles)
    turn_display_on

    # 2. Release systemd lid/idle inhibitor safely
    if [ -f "$INHIBIT_PID_FILE" ]; then
        inhibit_pid=$(cat "$INHIBIT_PID_FILE" 2>/dev/null)
        if [ -n "$inhibit_pid" ] && kill -0 "$inhibit_pid" 2>/dev/null; then
            comm=$(ps -p "$inhibit_pid" -o comm= 2>/dev/null)
            if [[ "$comm" == *"systemd-inhibit"* ]] || [[ "$comm" == *"sleep"* ]]; then
                kill "$inhibit_pid" 2>/dev/null || true
            fi
        fi
        rm -f "$INHIBIT_PID_FILE"
    fi
    pkill -f "systemd-inhibit.*ServerMode" 2>/dev/null || true

    # 3. Cleanly restart Waybar so its Hyprland IPC socket thread is fresh and actively updating
    pkill -x waybar 2>/dev/null || true
    hyprctl dispatch 'hl.dsp.exec_cmd("waybar")' 2>/dev/null || true

    # 4. Restore Intel Turbo Boost if it was changed
    if [ -f "$PREV_TURBO_FILE" ] && [ -w /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        cat "$PREV_TURBO_FILE" > /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null || true
        rm -f "$PREV_TURBO_FILE"
    fi

    # 5. Restore dirty writeback centisecs if it was changed
    if [ -f "$PREV_DIRTY_FILE" ] && [ -w /proc/sys/vm/dirty_writeback_centisecs ]; then
        cat "$PREV_DIRTY_FILE" > /proc/sys/vm/dirty_writeback_centisecs 2>/dev/null || true
        rm -f "$PREV_DIRTY_FILE"
    fi

    # 6. Restore previous CPU power profile if it was changed
    if [ -f "$PREV_PROFILE_FILE" ]; then
        prev_profile=$(cat "$PREV_PROFILE_FILE" 2>/dev/null)
        if [ -n "$prev_profile" ] && command -v powerprofilesctl &>/dev/null; then
            powerprofilesctl set "$prev_profile" 2>/dev/null
            pkill -SIGRTMIN+9 waybar 2>/dev/null || true
        fi
        rm -f "$PREV_PROFILE_FILE"
    fi

    # 7. Restore Bluetooth if it was unblocked before
    if [ -f "$PREV_BT_FILE" ]; then
        prev_bt=$(cat "$PREV_BT_FILE" 2>/dev/null)
        if [ "$prev_bt" = "unblocked" ] && command -v rfkill &>/dev/null; then
            rfkill unblock bluetooth 2>/dev/null || true
        fi
        rm -f "$PREV_BT_FILE"
    fi

    # Clean active state
    rm -f "$STATE_FILE"

    # 8. Notify user (longer timeout of 4000ms so it is visible upon opening laptop lid)
    notify-send -u normal -t 4000 -a "Server Mode" "Server Mode DEACTIVATED" \
        "• Displays & Waybar restored\n• Lid-close & sleep behaviors restored" 2>/dev/null || true
}

# Atomic lock using mkdir with retry (avoids FD inheritance leaks to background daemons)
acquire_lock() {
    local count=0
    while ! mkdir "$LOCK_DIR" 2>/dev/null; do
        sleep 0.05
        count=$((count + 1))
        if [ "$count" -ge 20 ]; then # 1 second timeout
            rm -rf "$LOCK_DIR" 2>/dev/null || true
            mkdir "$LOCK_DIR" 2>/dev/null || return 1
            break
        fi
    done
    return 0
}

release_lock() {
    rm -rf "$LOCK_DIR" 2>/dev/null || true
}

if ! acquire_lock; then
    exit 0
fi
trap release_lock EXIT INT TERM

case "${1:-toggle}" in
    on|enable)
        if ! is_active; then
            activate_server_mode
        fi
        ;;
    off|disable)
        if is_active; then
            deactivate_server_mode
        else
            turn_display_on
        fi
        ;;
    toggle)
        if is_active; then
            deactivate_server_mode
        else
            activate_server_mode
        fi
        ;;
    status)
        if is_active; then
            echo '{"text":"󰒋 Server","class":"active","tooltip":"Server Mode: Active\nLid sleep inhibited\nWi-Fi unthrottled"}'
        else
            echo '{"text":"󰌢 Laptop","class":"inactive","tooltip":"Server Mode: Inactive"}'
        fi
        ;;
    *)
        echo "Usage: $0 [toggle|on|off|status]"
        exit 1
        ;;
esac
