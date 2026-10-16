-- require(... .. ".notifications")
require(... .. ".popups")

local decorations = require(... .. ".decorations")
decorations.init()

-- local top_panel = require(... .. ".panels.top-panel")
-- local central_panel = require(... .. ".panels.central-panel")
-- local info_panel = require(... .. ".panels.info-panel")
-- local notification_panel = require(... .. ".panels.notification-panel")

local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")

-- awful.screen.connect_for_each_screen(function(s)
-- 	--- Panels
-- 	top_panel(s)
-- 	central_panel(s)
-- 	info_panel(s)
-- 	notification_panel(s)
-- end)

-- local panel_grabber = nil
-- local function any_panel_visible()
--     for s in screen do
--         if (s.central_panel and s.central_panel.visible)
--         or (s.notification_panel and s.notification_panel.visible)
--         or (s.info_panel and s.info_panel.visible) then
--             return true
--         end
--     end
--     return false
-- end
--
-- local function start_panel_grabber()
--     if panel_grabber then return end
--
--     panel_grabber = awful.keygrabber {
--         keybindings = {
--             awful.key {
--                 modifiers = {},
--                 key = "Escape",
--                 on_press = function()
--                     helpers.ui.close_panels()
--                     panel_grabber:stop()
--                     panel_grabber = nil
--                 end,
--             },
--         },
--         stop_key = "Escape",
--         stop_event = "press",
--         export_keybindings = false,
--     }
--     panel_grabber:start()
-- end
--
-- local function stop_panel_grabber()
--     if panel_grabber then
--         panel_grabber:stop()
--         panel_grabber = nil
--     end
-- end
--
-- -- Start/stop the grabber whenever panel visibility changes
-- awesome.connect_signal("central_panel::toggle", function()
--     gears.timer.delayed_call(function()
--         if any_panel_visible() then
--             start_panel_grabber()
--         else
--             stop_panel_grabber()
--         end
--     end)
-- end)
--
-- -- Also close on tag change
-- tag.connect_signal("property::selected", function()
--     helpers.ui.close_panels()
--     stop_panel_grabber()
-- end)
