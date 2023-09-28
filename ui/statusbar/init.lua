local wibox = require("wibox")
local awful = require("awful")

--- @type Theme
local beautiful = require("beautiful")

local info_widgets = require("ui/statusbar/info_widgets")
local taglist = require("ui/statusbar/taglist")
local launcher = require("ui/statusbar/launcher")
local power_menu_button = require("ui/statusbar/power_menu_button")

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
					right = beautiful.status_bar.info_widgets.icon_text_spacing,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = beautiful.status_bar.info_widgets.icon_text_spacing,
						info_widgets(s),
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
