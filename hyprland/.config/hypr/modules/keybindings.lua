---@module 'hl'

local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "nautilus"
local menu = os.getenv("HOME") .. "/.config/hypr/scripts/rofi-smart.sh"

-- Helper for keybindings using mainMod
local function bind_mod(key, dispatcher, flags)
    hl.bind(mainMod .. " + " .. key, dispatcher, flags)
end

-- App & Window Management
bind_mod("Return", hl.dsp.exec_cmd(terminal))
bind_mod("Q", hl.dsp.exec_cmd(terminal))
bind_mod("C", hl.dsp.window.close())
bind_mod("CONTROL + SHIFT + M", hl.dsp.exit())
bind_mod("E", hl.dsp.exec_cmd(fileManager))
bind_mod("V", hl.dsp.window.float({ action = "toggle" }))
bind_mod("space", hl.dsp.exec_cmd(menu))

-- Move focus
bind_mod("left", hl.dsp.focus({ direction = "left" }))
bind_mod("right", hl.dsp.focus({ direction = "right" }))
bind_mod("up", hl.dsp.focus({ direction = "up" }))
bind_mod("down", hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-10 (focus & move)
for i = 1, 10 do
    local key = i % 10
    bind_mod(tostring(key), hl.dsp.focus({ workspace = i }))
    bind_mod("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special Workspace (scratchpad)
bind_mod("S", hl.dsp.workspace.toggle_special("magic"))
bind_mod("SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Workspaces & Dragging
bind_mod("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind_mod("mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind_mod("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind_mod("mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Utilities & Custom Scripts
bind_mod("R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/screenrecord.sh"))
bind_mod("SHIFT + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/screenrecord.sh --region"))
bind_mod("D", hl.dsp.exec_cmd("wayscriber --daemon-toggle"))
bind_mod("l", hl.dsp.exec_cmd("hyprlock"))
bind_mod("f", hl.dsp.window.fullscreen())
bind_mod("escape", hl.dsp.exec_cmd("hyprpicker -f hex -a -q"))
bind_mod("k", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/toggle-dpms.sh"))
bind_mod("SHIFT + V", hl.dsp.exec_cmd("clipcat-menu insert"))
bind_mod("P", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/float-and-pin.sh"))
bind_mod("Z", hl.dsp.exec_cmd("dbus-send --session --type=method_call --dest=com.openwhispr.App /com/openwhispr/App com.openwhispr.App.Toggle"))

-- Hardware & Multimedia Keys (No modifier)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 1%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 1%-"), { locked = true, repeating = true })

-- Media Player Keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("hyprlock"))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 -o " .. os.getenv("HOME") .. "/Pictures/Screenshots"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o " .. os.getenv("HOME") .. "/Pictures/Screenshots"))
