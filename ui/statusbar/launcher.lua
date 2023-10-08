local awful = require("awful")
---@type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local hover_utils = require("utils.hover")
local ui_utils = require("utils.ui")

local theme = {
	bg_hover = beautiful.fg_focus,
}

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

	hover_utils.apply_hover_effects(widget, {
		hover_utils.cursor("hand1"),
		hover_utils.bg_hover(theme.bg_hover),
	})

	widget:connect_signal("button::release", function()
		--TODO Mayber write app launcher using awesome instead of rofi?
		awful.spawn.with_shell(os.getenv("HOME") .. "/.config/rofi/launcher.sh")
	end)

	ui_utils.generate_tooltip(widget, "Launcher")

	return widget
end

return create_widget
