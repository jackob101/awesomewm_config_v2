local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local ui_utils = require("utils.ui")

---@type Theme
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

---@param s Screen
---@return Widget
local function create(s)
	local widget = wibox.widget({
		widget = wibox.container.background,
		fg = beautiful.fg_normal,
		{
			widget = wibox.container.margin,
			top = dpi(6),
			bottom = dpi(6),
			{
				buttons = {
					awful.button({}, 1, function()
						awful.layout.inc(1)
					end),
					awful.button({}, 3, function()
						awful.layout.inc(-1)
					end),
					awful.button({}, 4, function()
						awful.layout.inc(1)
					end),
					awful.button({}, 5, function()
						awful.layout.inc(-1)
					end),
				},
				screen = s,
				widget = awful.widget.layoutbox,
			},
		},
	})

	ui_utils.generate_tooltip(widget, "test")
	gears.debug.dump(widget, "layout", 3)
	return widget
end

return create
