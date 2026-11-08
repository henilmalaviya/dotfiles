---@module 'hl'

-- Autostart Applications & Managed Systemd Services
hl.on("hyprland.start", function()
    -- Core Desktop Utilities
    hl.exec_cmd("hyprpaper & swaync & waybar & clipcatd &")
    
    -- Managed Background Services (systemd)
    hl.exec_cmd("systemctl --user start dotfiles-battery-notifier dotfiles-hypridle dotfiles-wayscriber dotfiles-wayvnc")

    -- Hex dictation service (Mod+Z / Alt+Space bindings need its local API ready).
    -- Started explicitly here because graphical-session.target is not reached in
    -- this GDM+Hyprland session and XDG autostart .desktop files are ignored.
    hl.exec_cmd("systemctl --user start hex.service")
end)
