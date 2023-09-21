local awful = require("awful")
---@type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local ui_utils = require("ui_utils")

function create_widget()
	local widget = wibox.widget({
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
		{
			{
				widget = wibox.widget.imagebox,
				image = beautiful.awesome_logo,
				resize = true,
				opacity = 1,
			},
			left = dpi(7),
			right = dpi(7),
			top = dpi(7),
			bottom = dpi(7),
			widget = wibox.container.margin,
		},
	})

	ui_utils.cursor_hover(widget)
	ui_utils.background_hover(widget, beautiful.bg_focus)

	widget:connect_signal("button::release", function()
		--TODO Mayber write app launcher using awesome instead of rofi?
		awful.spawn.with_shell(os.getenv("HOME") .. "/.config/rofi/launcher.sh")
	end)

	return widget
end

return create_widget
