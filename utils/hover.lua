local M = {}

---@param widget Widget
---@param effects (fun(widget: Widget):{enter: fun(), leave: fun()})[]
M.apply_hover_effects = function(widget, effects)
	---@type fun()[]
	local enter = {}
	---@type fun()[]
	local leave = {}

	for _, value in ipairs(effects) do
		local hover_effects = value(widget)
		table.insert(enter, hover_effects.enter)
		table.insert(leave, hover_effects.leave)
	end

	widget:connect_signal("mouse::enter", function()
		for _, value in pairs(enter) do
			value()
		end
	end)

	widget:connect_signal("mouse::leave", function()
		for _, value in pairs(leave) do
			value()
		end
	end)
end

---@param color string
M.bg_hover = function(color)
	---@param widget Widget
	return function(widget)
		local normal_bg = widget.bg
		return {
			enter = function()
				widget.bg = color
			end,
			leave = function()
				widget.bg = normal_bg
			end,
		}
	end
end

---@param color string
M.fg_hover = function(color)
	---@param widget Widget
	return function(widget)
		local normal_fg = widget.fg
		return {
			enter = function()
				print(normal_fg)
				widget.fg = color
			end,
			leave = function()
				widget.fg = normal_fg
			end,
		}
	end
end

-- I have no idea how this works... It's a magic. Why cursor cant be set
-- on widget creation?
--
---@param cursor_type string
M.cursor = function(cursor_type)
	return function(_)
		local old_cursor, old_wibox
		return {
			enter = function()
				local w = mouse.current_wibox
				if w then
					old_cursor, old_wibox = w.cursor, w
					w.cursor = "hand1"
				end
			end,
			leave = function()
				if old_wibox then
					old_wibox.cursor = old_cursor
					old_wibox = nil
				end
			end,
		}
	end
end

return M
