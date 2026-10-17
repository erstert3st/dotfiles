-- Window, layer and workspace rules: the parts of the KoolDots WindowRules.conf and
-- Garuda's own WindowRules.conf that matter for the apps in use.

local function rule(match, effects)
    effects.match = match
    hl.window_rule(effects)
end

-- Tags, used by the opacity and float rules below
local tags = {
    browser      = "^([Ff]irefox|org.mozilla.firefox|firedragon|[Cc]hromium|[Gg]oogle-chrome|zen)$",
    terminal     = "^(ghostty|kitty|kitty-dropterm)$",
    projects     = "^(VSCode|code|code-url-handler|codium|VSCodium|jetbrains-.+|dev.zed.Zed)$",
    im           = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop|org.telegram.desktop|teams-for-linux)$",
    games        = "^(gamescope|steam_app_\\d+)$",
    ["file-manager"] = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$",
    multimedia_video = "^([Mm]pv|vlc)$",
    settings     = "^(nm-applet|nm-connection-editor|blueman-manager|pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol|qt5ct|qt6ct|nwg-look|xdg-desktop-portal-gtk|org.kde.polkit-kde-authentication-agent-1|btrfs-assistant|timeshift-gtk|file-roller|org.gnome.FileRoller|gnome-disks)$",
    viewer       = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter|evince|eog|org.gnome.Loupe)$",
}
for tag, class in pairs(tags) do
    rule({ class = class }, { tag = "+" .. tag })
end
rule({ xdg_tag = "^(proton-game)$" }, { tag = "+games" })

-- Opacity per tag
rule({ tag = "browser" },      { opacity = "0.99 0.8" })
rule({ tag = "projects" },     { opacity = "0.9 0.8" })
rule({ tag = "im" },           { opacity = "0.94 0.86" })
rule({ tag = "file-manager" }, { opacity = "0.9 0.8" })
rule({ tag = "terminal" },     { opacity = "0.9 0.7" })
rule({ tag = "viewer" },       { float = true, center = true, opacity = "0.82 0.75" })
rule({ tag = "settings" },     { float = true, center = true, size = { "monitor_w*0.7", "monitor_h*0.7" }, opacity = "0.8 0.7" })
rule({ tag = "multimedia_video" }, { no_blur = true, opacity = "1.0" })
rule({ tag = "games" },        { no_blur = true, fullscreen = false })

-- Floating dialogs
rule({ title = "^(Authentication Required)$" }, { float = true, center = true })
rule({ title = "^(Add Folder to Workspace|Save As)$" }, { float = true, center = true, size = { "monitor_w*0.7", "monitor_h*0.6" } })
rule({ initial_title = "(Open Files)" }, { float = true, size = { "monitor_w*0.7", "monitor_h*0.6" } })
rule({ class = "^(mpv|com.github.rafostar.Clapper)$" }, { float = true })
rule({ class = "^([Qq]alculate-gtk)$" }, { float = true })
rule({ class = "^([Ss]team)$", title = "negative:^([Ss]team)$" }, { float = true })
rule({ class = "^(hyprland-share-picker)$" }, { float = true, center = true })

-- No idle/lock while something is fullscreen
rule({ class = ".*" }, { idle_inhibit = "fullscreen" })

-- Picture-in-picture (Firefox in English and German)
rule({ title = "^([Pp]icture-in-[Pp]icture|[Bb]ild-im-[Bb]ild)$" }, {
    float = true,
    move = { "monitor_w*0.72", "monitor_h*0.07" },
    opacity = "0.95 0.75",
    pin = true,
    keep_aspect_ratio = true,
    size = { "monitor_w*0.3", "monitor_h*0.3" },
})

-- Apps on their own special workspaces (ALT+S / ALT+D)
rule({ class = "(?i)spotify" }, { workspace = "special:spotify silent" })
rule({ class = "(discord|vesktop|WebCord)" }, { workspace = "special:discord silent" })

-- Dropdown terminal (SUPER+SHIFT+Return)
hl.workspace_rule({ workspace = "special:dropdown", on_created_empty = "kitty -o env=NO_TMUX=1 --class kitty-dropterm" })
rule({ class = "^kitty-dropterm$" }, {
    float = true,
    size = { "monitor_w*0.64", "monitor_h*0.65" },
    move = { "monitor_w*0.18", "monitor_h*0.1" },
})
