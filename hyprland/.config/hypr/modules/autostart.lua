---@module 'hl'

-- Autostart Applications & Managed Systemd Services
hl.on("hyprland.start", function()
    -- Core Desktop Utilities
    hl.exec_cmd("hyprpaper & swaync & waybar & clipcatd &")
    
    -- Managed Background Services (systemd)
    hl.exec_cmd("systemctl --user start dotfiles-battery-notifier dotfiles-handy dotfiles-hypridle dotfiles-wayscriber dotfiles-wayvnc")
end)
