---@module 'hl'

-- Input Devices & Touchpad Configuration
hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:super",
        repeat_delay = 250,
        repeat_rate = 30,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            drag_lock = false,
        },
    },
})
