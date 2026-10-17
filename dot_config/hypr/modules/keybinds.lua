-- Keybinds, derived from the effective binds on Garuda (hyprctl binds, KoolDots defaults plus
-- UserKeybinds.conf). Waybar, rofi and wallust menus are gone; noctalia covers launcher,
-- clipboard, notifications, wallpaper, OSD, screenshots and the session menu.
-- Descriptions stay literal in each hl.bind call and the "-- N. Category" headings stay:
-- the noctalia keybind-cheatsheet plugin (SUPER+H) scans this file for both.

local mainMod = "SUPER"
local noct = "noctalia msg "
local term = "kitty"
local files = "thunar"

-- hyprctl keyword is rejected by the Lua config, so runtime option changes go through hl.config.
local function zoom(factor)
    local current = math.max(hl.get_config("cursor:zoom_factor"), 1.0)
    hl.config({ cursor = { zoom_factor = math.max(current * factor, 1.0) } })
end

local layouts = { "dwindle", "master", "scrolling", "monocle" }
local function set_layout(name)
    hl.config({ general = { layout = name } })
end
local function next_layout()
    local current = hl.get_config("general:layout")
    for i, name in ipairs(layouts) do
        if name == current then
            return set_layout(layouts[i % #layouts + 1])
        end
    end
    set_layout(layouts[1])
end

local function scroll_direction(dir)
    hl.config({ scrolling = { direction = dir } })
end

local game_mode = false
local function toggle_game_mode()
    game_mode = not game_mode
    hl.config({
        animations = { enabled = not game_mode },
        decoration = { rounding = game_mode and 0 or 10, shadow = { enabled = not game_mode } },
        general = { gaps_in = game_mode and 0 or 1, gaps_out = game_mode and 0 or 1, border_size = game_mode and 0 or 1 },
    })
end

-- 1. Applications
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term), { description = "Open terminal" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(files), { description = "File manager" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("xdg-open https://"), { description = "Open default browser" })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(noct .. "panel-toggle launcher"), { description = "App launcher" })
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.workspace.toggle_special("dropdown"), { description = "Dropdown terminal" })

-- 2. Shell
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(noct .. "panel-toggle kenn/keybind-cheatsheet:cheatsheet"), { description = "Keybind cheat sheet" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(noct .. "panel-toggle kenn/keybind-cheatsheet:cheatsheet"), { description = "Search keybinds" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noct .. "panel-toggle clipboard"), { description = "Clipboard history" })
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd(noct .. "panel-toggle clipboard"), { description = "Clipboard history" })
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd(noct .. "panel-toggle launcher /emo"), { description = "Emoji picker" })
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(noct .. "panel-toggle launcher /emo"), { description = "Emoji picker" })
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd(noct .. "window-switcher"), { description = "Window switcher" })
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(noct .. "panel-toggle control-center notifications"), { description = "Notification history" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(noct .. "panel-toggle control-center"), { description = "Quick settings" })
hl.bind(mainMod .. " + CTRL + ALT + B", hl.dsp.exec_cmd(noct .. "bar-toggle"), { description = "Toggle bar" })
hl.bind(mainMod .. " + ALT + D", hl.dsp.exec_cmd(noct .. "dock-toggle"), { description = "Toggle dock" })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(noct .. "nightlight-force-toggle"), { description = "Toggle night light" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(noct .. "panel-toggle wallpaper"), { description = "Select wallpaper" })
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd(noct .. "wallpaper-random"), { description = "Random wallpaper" })
hl.bind("CTRL + ALT + Q", hl.dsp.exec_cmd("~/.config/hypr/bin/wallpaper-reject"), { description = "Reject wallpaper" })
hl.bind("CTRL + ALT + SHIFT + Q", hl.dsp.exec_cmd("~/.config/hypr/bin/wallpaper-reject --undo"), { description = "Undo reject wallpaper" })

-- 3. Session
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(noct .. "session lock"), { description = "Lock screen" })
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(noct .. "panel-toggle session"), { description = "Power menu" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(noct .. "panel-toggle session"), { description = "Exit menu" })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true, description = "Sleep" })

-- 4. Windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close active window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.signal({ signal = 15 }), { description = "Terminate active process" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Fullscreen" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize window" })
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }), { description = "Float current window" })
hl.bind(mainMod .. " + CTRL + O", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }), { description = "Toggle active window opacity" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Toggle pseudo (dwindle)" })
hl.bind(mainMod .. " + j", hl.dsp.window.cycle_next(), { description = "Cycle next window" })
hl.bind(mainMod .. " + k", hl.dsp.window.cycle_next({ next = false }), { description = "Cycle previous window" })
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end, { description = "Cycle next window" })

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }), { description = "Move window left" })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }), { description = "Move window right" })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }), { description = "Move window up" })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }), { description = "Move window down" })

hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "left" }), { description = "Swap window left" })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }), { description = "Swap window right" })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "up" }), { description = "Swap window up" })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "down" }), { description = "Swap window down" })

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true, description = "Resize left" })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true, description = "Resize right" })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true, description = "Resize up" })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true, description = "Resize down" })

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { description = "Move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { description = "Resize window" })

-- 5. Groups
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle group" })
hl.bind(mainMod .. " + CTRL + Tab", hl.dsp.group.next(), { description = "Next window in group" })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ into_group = "left" }), { description = "Move left into group" })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ into_group = "right" }), { description = "Move right into group" })
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ out_of_group = true }), { description = "Move out of group" })

-- 6. Layouts
hl.bind(mainMod .. " + ALT + L", next_layout, { description = "Next layout" })
hl.bind(mainMod .. " + ALT + 1", function() set_layout("dwindle") end, { description = "Layout dwindle" })
hl.bind(mainMod .. " + ALT + 2", function() set_layout("master") end, { description = "Layout master" })
hl.bind(mainMod .. " + ALT + 3", function() set_layout("scrolling") end, { description = "Layout scrolling" })
hl.bind(mainMod .. " + ALT + 4", function() set_layout("monocle") end, { description = "Layout monocle" })
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit"), { description = "Toggle split (dwindle)" })
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.layout("togglesplit"), { description = "Toggle split (dwindle)" })
hl.bind(mainMod .. " + M", hl.dsp.layout("splitratio 0.3 exact"), { description = "Split ratio 0.3 (dwindle)" })
hl.bind(mainMod .. " + I", hl.dsp.layout("addmaster"), { description = "Add master" })
hl.bind(mainMod .. " + CTRL + D", hl.dsp.layout("removemaster"), { description = "Remove master" })
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"), { description = "Swap with master" })
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("move +col"), { description = "Move to right column" })
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("move -col"), { description = "Move to left column" })
hl.bind(mainMod .. " + ALT + comma", hl.dsp.layout("swapcol l"), { description = "Swap columns left" })
hl.bind(mainMod .. " + ALT + period", hl.dsp.layout("swapcol r"), { description = "Swap columns right" })
hl.bind(mainMod .. " + R", hl.dsp.layout("colresize +conf"), { description = "Cycle column width (scrolling)" })
hl.bind(mainMod .. " + ALT + H", function() scroll_direction("right") end, { description = "Scroll horizontally" })
hl.bind(mainMod .. " + ALT + J", function() scroll_direction("down") end, { description = "Scroll vertically" })
hl.bind(mainMod .. " + ALT + S", function()
    scroll_direction(hl.get_config("scrolling:direction") == "right" and "down" or "right")
end, { description = "Toggle scroll direction" })
hl.bind(mainMod .. " + SHIFT + G", toggle_game_mode, { description = "Toggle game mode" })

-- 7. Workspaces
for i = 1, 10 do
    local key = "code:" .. (i + 9) -- number row by keycode, independent of the layout
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move to workspace " .. i })
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }), { description = "Move silently to workspace " .. i })
end
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Previous workspace" })
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }), { description = "Move to previous workspace" })
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }), { description = "Move to next workspace" })
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }), { description = "Move silently to previous workspace" })
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }), { description = "Move silently to next workspace" })
hl.bind(mainMod .. " + CTRL + F9", hl.dsp.workspace.move({ monitor = "l" }), { description = "Move workspace to left monitor" })
hl.bind(mainMod .. " + CTRL + F10", hl.dsp.workspace.move({ monitor = "r" }), { description = "Move workspace to right monitor" })
hl.bind(mainMod .. " + CTRL + F11", hl.dsp.workspace.move({ monitor = "u" }), { description = "Move workspace to upper monitor" })
hl.bind(mainMod .. " + CTRL + F12", hl.dsp.workspace.move({ monitor = "d" }), { description = "Move workspace to lower monitor" })

-- 8. Special workspaces
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special(), { description = "Toggle special workspace" })
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }), { description = "Move to special workspace" })
hl.bind("ALT + s", hl.dsp.workspace.toggle_special("spotify"), { description = "Spotify" })
hl.bind("ALT + d", hl.dsp.workspace.toggle_special("discord"), { description = "Discord" })
hl.bind("ALT + b", hl.dsp.workspace.toggle_special("browser"), { description = "Browser scratchpad" })
hl.bind("ALT + x", hl.dsp.workspace.toggle_special(), { description = "Toggle special workspace" })

-- 9. Media and volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noct .. "volume-up"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noct .. "volume-down"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(noct .. "volume-up 1"), { locked = true, repeating = true, description = "Volume up precise" })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(noct .. "volume-down 1"), { locked = true, repeating = true, description = "Volume down precise" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noct .. "volume-mute"), { locked = true, description = "Toggle mute" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noct .. "mic-mute"), { locked = true, description = "Toggle mic mute" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noct .. "media toggle"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noct .. "media toggle"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noct .. "media next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noct .. "media previous"), { locked = true, description = "Previous track" })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true, description = "Stop" })
hl.bind("Home", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play/pause" })
hl.bind("Prior", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })
hl.bind("Next", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })

-- 10. Screenshots and zoom
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noct .. "screenshot-fullscreen"), { description = "Screenshot now" })
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(noct .. "screenshot-region"), { description = "Screenshot area" })
hl.bind("ALT + SHIFT + S", hl.dsp.exec_cmd(noct .. "screenshot-region"), { description = "Screenshot area" })
hl.bind(mainMod .. " + CTRL + Print", hl.dsp.exec_cmd("sleep 5 && " .. noct .. "screenshot-fullscreen"), { description = "Screenshot in 5s" })
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd("sleep 10 && " .. noct .. "screenshot-fullscreen"), { description = "Screenshot in 10s" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(noct .. "screenshot-annotate"), { description = "Screenshot and annotate" })
hl.bind(mainMod .. " + ALT + mouse_down", function() zoom(2.0) end, { description = "Zoom in" })
hl.bind(mainMod .. " + ALT + mouse_up", function() zoom(0.5) end, { description = "Zoom out" })
