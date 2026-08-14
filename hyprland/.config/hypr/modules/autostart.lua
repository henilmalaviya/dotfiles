---@module 'hl'

-- Autostart Applications & Services
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper & swaync & waybar & battery-notifier & hyprsunset & clipcatd & wayscriber --daemon & openwhispr &")
    hl.exec_cmd("rm -f /tmp/waybar_caffeine_state && hypridle")
    hl.exec_cmd("bash -c 'while true; do wayvnc; sleep 3; done'")
end)
