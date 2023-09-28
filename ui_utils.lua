local awful = require("awful")
local gears = require("gears")
---@type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

---@class UiUtils
local utils = {}

function utils.generate_tooltip(target, text)
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

function utils.cursor_hover(widget)
	local old_cursor, old_wibox
	widget:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			old_cursor, old_wibox = w.cursor, w
			w.cursor = "hand1"
		end
	end)

	widget:connect_signal("mouse::leave", function()
		if old_wibox then
			old_wibox.cursor = old_cursor
			old_wibox = nil
		end
	end)
end

---@param color string hover color
function utils.background_hover(widget, color)
	widget:connect_signal("mouse::enter", function()
		if widget.bg ~= color then
			widget.backup = widget.bg
			widget.has_backup = true
		end
		widget.bg = color
	end)
	widget:connect_signal("mouse::leave", function()
		if widget.has_backup then
			widget.bg = widget.backup
		end
	end)
end

---@param color string hover color
function utils.fg_hover(widget, color)
	widget:connect_signal("mouse::enter", function()
		if widget.fg ~= color then
			widget.backup = widget.fg
			widget.has_backup = true
		end
		widget.fg = color
	end)
	widget:connect_signal("mouse::leave", function()
		if widget.has_backup then
			widget.fg = widget.backup
		end
	end)
end

---@param effects fun(widget: Widget)[]
function utils.apply_hover_effects(effects) end

---@param radius number
function utils.rrect(radius)
	return function(cr, width, height)
		return gears.shape.rounded_rect(cr, width, height, radius)
	end
end

---comment
---@param radius number
---@param tl boolean
---@param tr boolean
---@param bl boolean
---@param br boolean
---@return function
function utils.prrect(radius, tl, tr, br, bl)
	return function(cr, width, height)
		return gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
	end
end

---@param text string
function utils.bold(text)
	return "<b>" .. text .. "<b>"
end

return utils
