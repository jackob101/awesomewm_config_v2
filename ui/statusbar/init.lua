local wibox = require("wibox")
local awful = require("awful")

--- @type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local taglist = require("ui/statusbar/taglist")
local launcher = require("ui/statusbar/launcher")
local power_menu_button = require("ui/statusbar/power_menu")
local volume = require("ui/statusbar/volume")
local clock = require("ui/statusbar/clock")
local calendar = require("ui/statusbar/calendar")
local systray = require("ui/statusbar/systray")

local theme = {
	right = {
		spacing = dpi(15),
	},
}

---@param s Screen
local function create_bar_for_screen(s)
	local widget = awful.wibar({
		position = "bottom",
		screen = s,
		height = beautiful.status_bar.height,
		bg = beautiful.bg_normal,
	})

	widget:setup({
		layout = wibox.layout.stack,
		{
			layout = wibox.layout.align.horizontal,
			expand = "outside",
			widget = wibox.container.background,
			{
				layout = wibox.layout.align.horizontal,
				expand = "inside",
				{
					layout = wibox.layout.fixed.horizontal,
					launcher(),
				},
				nil,
				{
					widget = wibox.container.margin,
					right = theme.right.spacing,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = theme.right.spacing,
						volume(),
						clock(),
						calendar(),
						systray(s),
						power_menu_button(),
					},
					--TODO Controll panel toggle
				},
			},
		},
		{
			layout = wibox.layout.align.horizontal,
			expand = "outside",
			nil,
			taglist(s),
		},
	})
end

awful.screen.connect_for_each_screen(function(s)
	create_bar_for_screen(s)
end)
