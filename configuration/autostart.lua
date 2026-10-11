local awful = require("awful")
local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()
local helpers = require("helpers")

local function autostart_apps()
	--- Compositor
	helpers.run.check_if_running("picom", nil, function()
		awful.spawn("picom --config " .. config_dir .. "configuration/picom.conf", false)
	end)
	--- Music Server
	-- helpers.run.run_once_pgrep("mpd")
	-- helpers.run.run_once_pgrep("mpDris2")
	--- Polkit Agent
	helpers.run.run_once_ps(
		"lxpolkit",
		"/usr/bin/lxpolkit"
	)
	--- Other stuff
	helpers.run.run_once_grep("blueman-applet")
	helpers.run.run_once_grep("nm-applet")


	-- Useful Cinnamon leftovers
	awful.spawn.once("csd-xsettings")
	-- optional:
	awful.spawn.once("cinnamon-screensaver")

	-- Utilities
	awful.spawn.once("ulauncher --hide-window --no-window-shadow")
	awful.spawn.once("touchpad-watcher.sh")
	-- awful.spawn.once("gammastep -O 3500")

	-- personal configurations
	awful.spawn.with_shell("setxkbmap -option 'ctrl:nocaps,shift:both_capslock_cancel'")
end

autostart_apps()
