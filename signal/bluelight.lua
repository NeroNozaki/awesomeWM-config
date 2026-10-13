local awful = require("awful")

-- ============================================================
-- Easy configuration
-- ============================================================
local DEFAULT_ENABLED=true          -- start with blue light on?
local TEMPERATURE=3000
-- ============================================================

local blue_light_state = false

local _bluelight = {}



local kill_state = function()
	awful.spawn.easy_async_with_shell(
		[[
			gammastep -x
			kill -9 $(pgrep gammastep) 2>/dev/null
			]],
		function()
			blue_light_state = false
		end
	)
end

local function set_blue_light(enabled)
    if enabled then
        awful.spawn.easy_async_with_shell(
            string.format("gammastep -O %d -r &>/dev/null &", TEMPERATURE),
            function()
                blue_light_state = true
            end
        )
    else
		kill_state()
    end
end

-- Apply the default on startup
kill_state()
set_blue_light(DEFAULT_ENABLED)

_bluelight.toggle_bluelight = function()
	set_blue_light(not blue_light_state)
end

return _bluelight
