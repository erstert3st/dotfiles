-- General compositor settings, carried over from the KoolDots SystemSettings.conf and
-- UserDecorations.conf that Garuda used. Colors come from noctalia (see hyprland.lua).

hl.config({
    general = {
        layout = "dwindle",
        border_size = 1,
        gaps_in = 1,
        gaps_out = 1,
        resize_on_border = true,
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.3,
        dim_special = 0.8,
        shadow = {
            enabled = true,
            range = 3,
            render_power = 1,
        },
        blur = {
            enabled = false,
            size = 2,
            passes = 2,
            new_optimizations = true,
            xray = true,
            ignore_opacity = true,
            special = true,
            popups = true,
        },
    },

    input = {
        kb_layout = "at",
        repeat_rate = 50,
        repeat_delay = 300,
        sensitivity = 0,
        numlock_by_default = true,
        follow_mouse = 1,
        float_switch_override_focus = 0,
    },

    dwindle = {
        preserve_split = true,
        smart_resizing = true,
        use_active_for_splits = true,
        smart_split = false,
        default_split_ratio = 1.0,
        split_bias = 0,
        precise_mouse_move = false,
        special_scale_factor = 0.8,
    },

    master = {
        new_status = "slave",
        new_on_top = false,
        new_on_active = "none",
        orientation = "left",
        mfact = 0.55,
        slave_count_for_center_master = 2,
        center_master_fallback = "left",
        smart_resizing = true,
        drop_at_cursor = true,
        always_keep_position = false,
    },

    scrolling = {
        column_width = 0.8,
        fullscreen_on_one_column = true,
        direction = "right",
        follow_focus = true,
        -- presets for SUPER+R (colresize +conf)
        explicit_column_widths = "0.25, 0.333, 0.5, 0.667, 0.75, 1.0",
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        vrr = 0, -- MPV goes black when maximized with VRR on
        mouse_move_enables_dpms = true,
        enable_swallow = false,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
        enable_anr_dialog = true,
        anr_missed_pings = 15,
        allow_session_lock_restore = true, -- lockscreen survives resume from suspend
        on_focus_under_fullscreen = 1,
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },

    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },

    render = {
        direct_scanout = 0,
    },

    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = 0,
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = true,
        no_break_fs_vrr = 0,
        min_refresh_rate = 24,
        hotspot_padding = 1,
        inactive_timeout = 0,
        zoom_factor = 1.0,
        zoom_rigid = false,
        zoom_detached_camera = true,
        hide_on_key_press = true,
        hide_on_touch = false,
        hide_on_tablet = false,
        use_cpu_buffer = 0,
    },
})
