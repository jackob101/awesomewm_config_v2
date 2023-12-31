local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

--- @type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui_utils = require("utils.ui")

local theme = {
	font = beautiful.status_bar.font,
	font_fg = beautiful.fg_normal,
}

---@return Widget
local function create()
	local date_widget = wibox.widget({
		widget = wibox.container.background,
		fg = theme.font_fg,
		{
			widget = wibox.widget.textclock,
			format = "%a %b %d",
			font = theme.font,
		},
	})

	local date_widget_tooltip = ui_utils.generate_tooltip(date_widget, nil)
	date_widget:connect_signal("mouse::enter", function()
		date_widget_tooltip.text = os.date("%A %B %d %Y")
	end)

	return date_widget
end

return create
