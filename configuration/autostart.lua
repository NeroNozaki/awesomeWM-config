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
	
	helpers.run.run_once_pgrep("spotifast")
	
	--- Polkit Agent
	helpers.run.run_once_ps(
		"lxpolkit",
		"/usr/bin/lxpolkit"
	)
	--- Other stuff
	helpers.run.run_once_grep("blueman-applet")
	helpers.run.run_once_grep("nm-applet")
	helpers.run.run_once_grep("dunst")


	-- Useful Cinnamon leftovers
	awful.spawn.once("csd-xsettings")

	-- Utilities
	-- awful.spawn.once("ulauncher --hide-window --no-window-shadow")
	awful.spawn.once("touchpad-watcher.sh")
	awful.spawn.once("brightnessctl -n 1")
	helpers.run.check_if_running("polybar",
		-- if it's running,
		function()
			awful.spawn("pkill polybar")
			awful.spawn.once("polybar -r -c $HOME/.config/awesome/ui/polybar/config.ini")
		end,

		-- else,
		function()
			awful.spawn.once("polybar -r -c $HOME/.config/awesome/ui/polybar/config.ini")
		end
	)

	helpers.run.check_if_running("xss-lock", nil, function()
		awful.spawn("xss-lock -s c2 -l -- betterlockscreen -l dimblur &")
	end)

	-- personal configurations
	awful.spawn.with_shell("~/.dotfiles/scripts/keyboard-start-config.sh")
end

autostart_apps()
