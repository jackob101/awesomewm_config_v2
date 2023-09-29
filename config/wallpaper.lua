---@type Awful
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
---@type Theme
local beautiful = require("beautiful")

local connected_screens = {}

screen.connect_signal("request::wallpaper", function(s)
	table.insert(connected_screens, s)
end)

function CHANGE_WALLPAPER()
	-- TODO: Add option to select collection after changing to wallman
	local wallpaper = gears.filesystem.get_random_file_from_dir(beautiful.wallman_storage)

	for index, value in ipairs(connected_screens) do
		awful.wallpaper({
			screen = value,
			widget = {
				{
					image = beautiful.wallman_storage .. "/" .. wallpaper,
					upscale = true,
					downscale = true,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				tiled = false,
				widget = wibox.container.tile,
			},
		})
	end
end

gears.timer({
	timeout = 900,
	call_now = true,
	autostart = true,
	callback = CHANGE_WALLPAPER,
})
