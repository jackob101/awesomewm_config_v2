local wibox = require("wibox")

--- @type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local theme = {
	text_font = beautiful.font_name .. beautiful.status_bar.font_size,
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
			font = theme.text_font,
		},
	})
end

return create
