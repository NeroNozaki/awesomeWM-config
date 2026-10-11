local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local widgets = require("ui.widgets")

--- Blue-Light Widget
--- ~~~~~~~~~~~~~~~~~

-- ============================================================
-- Easy configuration
-- ============================================================
local DEFAULT_ENABLED = true          -- start with blue light on?
local TEMPERATURE     = 3000
-- ============================================================

local blue_light_state = false

local function button(icon)
    return widgets.button.text.state({
        forced_width = dpi(60),
        forced_height = dpi(60),
        normal_bg = beautiful.one_bg3,
        normal_shape = gears.shape.circle,
        on_normal_bg = beautiful.accent,
        text_normal_bg = beautiful.accent,
        text_on_normal_bg = beautiful.one_bg3,
        font = beautiful.icon_font .. "Round ",
        size = 17,
        text = icon,
    })
end

local widget = button("")

local update_widget = function()
    if blue_light_state then
        widget:turn_on()
    else
        widget:turn_off()
    end
end

local kill_state = function()
	awful.spawn.easy_async_with_shell(
		[[
			gammastep -x
			kill -9 $(pgrep gammastep) 2>/dev/null
			]],
		function()
			blue_light_state = false
			update_widget()
		end
	)
end

local function set_blue_light(enabled)
    if enabled then
        awful.spawn.easy_async_with_shell(
            string.format("gammastep -O %d -r &>/dev/null &", TEMPERATURE),
            function()
                blue_light_state = true
                update_widget()
            end
        )
    else
		kill_state()
    end
end

-- Apply the default on startup
kill_state()
set_blue_light(DEFAULT_ENABLED)

local toggle_action = function()
    set_blue_light(not blue_light_state)
end

widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
    toggle_action()
end)))

return widget
