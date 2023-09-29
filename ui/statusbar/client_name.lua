local wibox = require("wibox")
local awful = require("awful")

--- @type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local hover_utils = require("utils.hover")

local theme = {
	hover_fg = beautiful.fg_focus,
}

---@param textbox Widget
---@param c Client
local function update_text(textbox, c)
	if c.class == nil then
		return
	end

	if c.floating then
		textbox.text = "✈  " .. c.class
	else
		textbox.text = c.class
	end
end

---@param s Screen
local function create(s)
	local widget = wibox.widget({
		widget = wibox.container.background,
		{
			id = "constraint",
			widget = wibox.container.constraint,
			width = 350,
			strategy = "max",
			{
				id = "text_widget",
				widget = wibox.widget.textbox,
			},
		},
	})

	hover_utils.apply_hover_effects(widget, {
		hover_utils.cursor("hand1"),
		hover_utils.fg_hover(theme.hover_fg),
	})

	client.connect_signal("focus", function(c)
		if c.screen.index == s.index then
			update_text(widget.constraint.text_widget, c)
		end
	end)
	client.connect_signal("property::floating", function(c)
		if c.screen.index == s.index then
			update_text(widget.constraint.text_widget, c)
		end
	end)
	tag.connect_signal("property::selected", function(t)
		if t.screen.index == s.index then
			if #t:clients() == 0 then
				widget.constraint.text_widget.text = ""
			end
		end
	end)

	return widget
end

return create
