local wibox = require("wibox")

--- @type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local theme = {
	font = beautiful.status_bar.font,
	font_fg = beautiful.fg_normal,
}

---@return Widget
local function create()
	return wibox.widget({
		widget = wibox.container.background,
		fg = theme.font_fg,
		{
			widget = wibox.widget.textclock,
			format = "%H:%M",
			font = theme.font,
		},
	})
end

return create
