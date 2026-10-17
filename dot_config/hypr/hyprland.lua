-- Hyprland entry point. Own setup in Lua, managed by chezmoi (dot_config/hypr), no KoolDots.
-- Machine-specific parts (env, monitors, startup apps) are chezmoi templates in modules/.

require("modules.env")
require("modules.monitors")
require("modules.settings")
require("modules.animations")
require("modules.rules")
require("modules.keybinds")
require("modules.startup")

-- Border and group colors from noctalia's hyprland template (noctalia.lua next to this file,
-- written by noctalia itself). noctalia appends require("noctalia").apply_theme() here unless
-- that exact text is present, so it stays literal. pcall: the file exists only after
-- noctalia's first template run.
local ok, noctalia = pcall(function() return require("noctalia") end)
if ok then
    noctalia.apply_theme()
    hl.config({
        decoration = {
            shadow = {
                color = noctalia.colors.primary,
                color_inactive = noctalia.colors.surface,
            },
        },
    })
end
