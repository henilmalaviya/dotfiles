---@module 'hl'

-- Hyprland Configuration Entrypoint (Lua Syntax)

-- Sourced Display & System Modules
require("modules.display")
require("modules.autostart")
require("modules.env")
require("modules.look")
require("modules.animations")

-- Workspace & Window Rules
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name = "border_size_w_tv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
})

hl.window_rule({
    name = "border_size_f_1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
})

-- Layout & Misc Settings
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
    debug = {
        vfr = true,
    },
})

-- Sourced Input, Keybindings, Rules & Local Overrides
require("modules.input")
require("modules.keybindings")
require("modules.rules")
require("local")

-- Reload Hook
hl.on("config.reloaded", function()
    hl.exec_cmd("touch ~/.config/hypr/local.conf")
end)
