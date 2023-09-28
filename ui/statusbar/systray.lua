local wibox = require("wibox")

local dpi = require("beautiful.xresources").apply_dpi

local theme = {
	top_margin = dpi(5),
	bottom_margin = dpi(5),
}

---@param s Screen
---@return Widget?
local function create(s)
	if s.index ~= 1 then
		return nil
	end

	return wibox.widget({
		widget = wibox.container.margin,
		top = theme.top_margin,
		bottom = theme.bottom_margin,
		{
			widget = wibox.widget.systray,
			screen = "primary",
		},
	})
end

return create
