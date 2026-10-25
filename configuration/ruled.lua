local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")
local helpers = require("helpers")

--- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

ruled.client.connect_signal("request::rules", function()
	--- Global
	ruled.client.append_rule({
		id = "global",
		rule = { },
		properties = {
			raise = true,
			size_hints_honor = false,
			honor_workarea = true,
			honor_padding = true,
			-- screen = awful.screen.preferred,
			screen = awful.screen.focused,
			focus = awful.client.focus.filter,
			border_color = beautiful.border_color_normal,
			titlebars_enabled = beautiful.titlebar_enabled,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	--- Tasklist order
	ruled.client.append_rule({
		id = "tasklist_order",
		rule = {},
		properties = {},
		callback = awful.client.setslave,
	})

	--- Titlebar rules
	ruled.client.append_rule({
		id = "titlebars",
		rule_any = {
			class = {
				"Spotify",
				"Org.gnome.Nautilus",
				"Peek",
			},
		},
		properties = {
			titlebars_enabled = false,
		},
	})

	--- Float
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = {
				"Devtools", --- Firefox devtools
			},
			class = {
				"Lxappearance",
				"Nm-connection-editor",
				"Nemo",
				"Blueman-manager",
			},
			name = {
				"Event Tester", -- xev
				"Ulauncher Preferences",
				"nemo",
			},
			role = {
				"AlarmWindow",
				"pop-up",
				"GtkFileChooserDialog",
				"conversation",
			},
			type = {
				"dialog",
			},
		},
		properties = {
			floating = true,
			placement = helpers.client.centered_client_placement,
			border_color = beautiful.border_color_floating,
		},
	})

	--- Centered
	ruled.client.append_rule({
		id = "centered",
		rule_any = {
			type = {
				"dialog",
			},
			class = {
				--- "discord",
			},
			role = {
				"GtkFileChooserDialog",
				"conversation",
			},
			name = {
				"Ulauncher Preferences",
			},
		},
		properties = { placement = helpers.client.centered_client_placement },
	})

	--- Music clients (usually a terminal running ncmpcpp)
	ruled.client.append_rule({
		rule_any = {
			class = {
				"music",
			},
			instance = {
				"music",
			},
		},
		properties = {
			floating = true,
			width = screen_width * 0.40,
			height = screen_height * 0.42,
			placement = helpers.client.centered_client_placement,
		},
	})

	--- Image viewers
	ruled.client.append_rule({
		rule_any = {
			class = {
				"feh",
				"imv",
				"Xviewer"
			},
		},
		properties = {
			floating = true,
			width = screen_width * 0.7,
			height = screen_height * 0.75,
		},
		callback = function(c)
			awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
		end,
	})

	ruled.client.append_rule({
		rule = { class = "LibreWolf" },
		properties = {
			size_hints_honor = false,
			screen = 1,
			tag = "2"
		}
	})

	ruled.client.append_rule({
		rule = { class = "spotifast" },
		properties = {
			minimized = true,
			tag = "3",
		},
	})

	ruled.client.append_rule({
		rule = { class = { "Polybar" },
			properties = {
				focusable = false,
				focus = false,
				raise = false,
			},
		},
	})
end)

-- Helper: is this the only tiled client on its screen?
local function is_sole_tiled(c)
    if c.floating or c.maximized or c.fullscreen then
        return false
    end
    local count = 0
    for _, cl in ipairs(c.screen.tiled_clients) do
        if not cl.floating and not cl.minimized then
            count = count + 1
            if count > 1 then return false end
        end
    end
    return count == 1
end

local function update_border(c)
    if not c or not c.valid then return end

    if is_sole_tiled(c) then
        c.border_width = 0
    else
        c.border_width = beautiful.border_width or 2
    end

    if c == client.focus and not c.floating then
        c.border_color = beautiful.border_color_active
    else
        c.border_color = beautiful.border_color_normal
    end
end

-- Keep borders correct on every relevant event
client.connect_signal("focus", update_border)
client.connect_signal("unfocus", update_border)
client.connect_signal("property::floating", update_border)
client.connect_signal("property::maximized", update_border)
client.connect_signal("property::fullscreen", update_border)
client.connect_signal("manage", update_border)
client.connect_signal("unmanage", function()
    -- update the remaining clients on that screen
    for s in screen do
        for _, c in ipairs(s.clients) do
            update_border(c)
        end
    end
end)

tag.connect_signal("property::selected", function()
    for s in screen do
        for _, c in ipairs(s.clients) do
            update_border(c)
        end
    end
end)

tag.connect_signal("property::layout", function()
    for s in screen do
        for _, c in ipairs(s.clients) do
            update_border(c)
        end
    end
end)
