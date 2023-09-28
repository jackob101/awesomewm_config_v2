local awful = require("awful")
local gears = require("gears")
---@type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local M = {}

function M.generate_tooltip(target, text)
	return awful.tooltip({
		objects = { target },
		text = text,
		bg = beautiful.bg_normal,
		mode = "outside",
		margins = dpi(10),
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, dpi(2))
		end,
		gaps = dpi(5),
	})
end

return M
