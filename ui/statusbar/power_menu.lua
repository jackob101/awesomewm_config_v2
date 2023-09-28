local wibox = require("wibox")
local hover_utils = require("utils.hover")

--- @type Theme
local beautiful = require("beautiful")

local theme = {
	fg = beautiful.fg_normal,
	fg_hover = beautiful.fg_focus,
}

---@return Widget|nil
local function create()
	if EXIT_SCREEN_MODULE == nil then
		print("exit screen module is null")
		return nil
	end

	local widget = wibox.widget({
		widget = wibox.container.background,
		fg = theme.fg,
		{
			widget = wibox.widget.textbox,
			text = "",
			font = beautiful.icon_font .. 16,
		},
	})

	hover_utils.apply_hover_effects(widget, {
		hover_utils.fg_hover(theme.fg_hover),
		hover_utils.cursor("hand1"),
	})

	-- ui_utils.cursor_hover(widget)
	-- ui_utils.fg_hover(widget, theme.fg_hover)

	widget:connect_signal("button::release", function()
		EXIT_SCREEN_MODULE.start()
	end)

	return widget
end

return create
