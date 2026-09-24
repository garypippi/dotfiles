-- Monitors

hl.monitor({
    output    = "DP-1",
    mode      = "2560x1440@165.00",
    position  = "0x0",
    scale     = "1"
})
hl.monitor({
    output    = "DP-2",
    mode      = "2560x1600@119.96",
    position  = "-1000x0",
    scale     = "1.6",
    transform = 1
})
hl.monitor({
    output    = "HDMI-A-1",
    mode      = "3840x1100@60.00",
    position  = "0x1440",
    scale     = "1.66667"
})

for i = 1,8 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor   = "DP-1",
        default   = true
    })
end

hl.workspace_rule({
    workspace = "9",
    monitor   = "HDMI-A-1",
    default   = true
})

-- Config

hl.config({
    cursor = {
        -- 1じゃないとずれる
        no_hardware_cursors = 1,
        no_warps = true,
    },
    dwindle = {
        preserve_split = true
    },
    decoration = {
        rounding = 8,
    },
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = '#636bff',
        }
    },
    misc = {
        key_press_enables_dpms = true,
        mouse_move_enables_dpms = true
    },
})

-- Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("gentoo-pipewire-launcher")
    hl.exec_cmd('SSH_ASKPASS=askpass.sh ssh-agent -a "$XDG_RUNTIME_DIR/ssh-agent.sock"')
    hl.exec_cmd("jacin")
    hl.exec_cmd("swaybg -o 'DP-1' -m fill -i ~/Pictures/desktop-DP-1.png")
    hl.exec_cmd("swaybg -o 'DP-2' -m fill -i ~/Pictures/desktop-DP-2.png")
    hl.exec_cmd("swaybg -o 'HDMI-A-1' -m fill -i ~/Pictures/desktop-HDMI-A-1.png")
    hl.exec_cmd("openrgb --profile garypippi")
end)

-- Window rules

hl.window_rule({
    match  = { class = "chotto" },
    float  = true,
    center = true,
    size   = {720,480}
})
hl.window_rule({
    match  = { class = "mpv" },
    float  = true,
    center = true,
    size   = {1280,800}
})
hl.window_rule({
    name  = "ueberzugpp-album-art",
    match = { title = "ueberzugpp_.*" },
    float       = true,
    no_focus    = true,
    workspace   = "9 silent",
    border_size = 0,
    rounding    = 0,
    opacity     = 0,
    no_anim     = true,
})

-- Binds

local volume = function (args)
    return hl.dsp.exec_cmd("pactl " .. args .. "; pkill -USR1 -x pippipit")
end

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

hl.bind("SUPER + semicolon", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + p", hl.dsp.exec_cmd("alacritty --class chotto"))
hl.bind("SUPER + c", hl.dsp.exec_cmd("alacritty --class chotto -e nvim -c startinsert clipboard://"))

hl.bind("SUPER + d", hl.dsp.exec_cmd("fuzzel"))
-- capture (screenshot / recording)
local capture_targets = {
    r = "region", w = "window", m = "output",
    ["1"] = "16:9", ["2"] = "4:3", ["3"] = "1:1", ["4"] = "9:16",
}

for key, action in pairs({ s = "shot", r = "rec", ["ALT + r"] = "reca" }) do
    hl.bind("SUPER + " .. key, hl.dsp.exec_cmd("capture.sh " .. action))
    hl.define_submap(action, "reset", function()
        for k, target in pairs(capture_targets) do
            hl.bind(k, hl.dsp.exec_cmd("capture.sh " .. action .. " " .. target))
        end
        hl.bind("escape", hl.dsp.submap("reset"))
    end)
end

-- show the key hint while in a capture submap (name is "" on reset)
hl.on("keybinds.submap", function(name)
    hl.exec_cmd("capture.sh hint " .. name)
end)

-- jacin
hl.bind("ALT + q", hl.dsp.exec_cmd("jacin toggle"))
hl.bind("ALT + w", hl.dsp.exec_cmd("jacin focus"))

hl.bind("SUPER + f", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + m", function()
    local w = hl.get_active_window()
    if not w then return end

    hl.dispatch(hl.dsp.window.fullscreen_state({
        internal = 0,
        client = w.fullscreen_client == 2 and 0 or 2,
    }))
end)

hl.bind("SUPER + ALT + t", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + ALT + s", hl.dsp.layout("swapsplit"))

hl.bind("SUPER + ALT + k", hl.dsp.window.close())

-- Focus
hl.bind("ALT + h", hl.dsp.focus({ direction = "l" }))
hl.bind("ALT + l", hl.dsp.focus({ direction = "r" }))
hl.bind("ALT + j", hl.dsp.focus({ direction = "d" }))
hl.bind("ALT + k", hl.dsp.focus({ direction = "u" }))
hl.bind("ALT + f", hl.dsp.focus({ window = "floating" }))
hl.bind("ALT + t", hl.dsp.focus({ window = "tiled" }))

for i = 1,9 do
    hl.bind("ALT + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + ALT + h", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + ALT + l", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("ALT + p", hl.dsp.workspace.toggle_special())
hl.bind("ALT + s", hl.dsp.window.move({ workspace = "special" }))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioMute", volume("set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("code:123", volume("set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("code:122", volume("set-sink-volume @DEFAULT_SINK@ -5%"))
