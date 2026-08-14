---@module 'hl'

-- Ignore maximize requests from apps
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix dragging issues with XWayland
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- Calculator Float Rule
hl.window_rule({
    name = "calculator-float",
    match = {
        class = "^(org\\.gnome\\.Calculator)$",
    },
    float = true,
    size = "350 250",
    center = true,
})

-- Calculator Bravo Rule
hl.window_rule({
    name = "calculator-bravo",
    match = {
        class = "^(org\\.gnome\\.Calculator)$",
    },
    workspace = "special:bravo",
    move = "50 200",
})
