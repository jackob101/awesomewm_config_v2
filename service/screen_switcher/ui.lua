local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
---@type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local ui_utils = require("ui_utils")

local theme = {
	overlay_bg_color = beautiful.bg_minimize .. "99",
	bg_color = beautiful.bg_normal,
	box_margin = dpi(40),
}

---@type {popup: Widget, set_content: fun(widget)}[]
local attached_popups = {}

---@param s Screen
local function create_popup_for_screen(s)
	local popup_content = wibox.widget({
		layout = wibox.layout.manual,
	})

	local popup = awful.popup({
		screen = s,
		ontop = true,
		x = s.geometry.x,
		y = s.geometry.y,
		bg = theme.overlay_bg_color,
		visible = false,
		widget = {
			widget = wibox.container.background,
			forced_height = s.geometry.height,
			forced_width = s.geometry.width,
			popup_content,
		},
	})

	---@param content_widget Widget
	local function set_content(content_widget)
		popup_content:reset()
		for i, value in ipairs(content_widget) do
			if value ~= nil then
				popup_content:add(value)
			end
		end
	end

	table.insert(attached_popups, s.index, { popup = popup, set_content = set_content })
end

---@param s Screen
local function generate_screen_index(s)
	return wibox.widget({
		widget = wibox.container.place,
		fill_vertical = true,
		fill_horizontal = true,
		valign = "center",
		halign = "center",
		{
			widget = wibox.widget.textbox,
			text = s.index,
			font = beautiful.font_name .. "360",
			valign = "center",
			halign = "center",
		},
	})
end

local M = {}

local function generate_string_of_numbers(from, to)
	local result = ""
	for i = from, to, 1 do
		if i == to then
			result = result .. i
		else
			result = result .. i .. " / "
		end
	end
	return result
end

local function generate_help_box()
	return wibox.widget({
		widget = wibox.container.background,
		bg = theme.bg_color,
		shape = ui_utils.rrect(5),
		point = function(geo, args)
			return {
				x = 20,
				y = args.parent.height - geo.height - 20,
			}
		end,
		{
			widget = wibox.container.margin,
			margins = theme.box_margin,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(40),
				spacing_widget = wibox.widget.separator,
				{
					widget = wibox.widget.textbox,
					text = "Help",
					halign = "center",
					font = beautiful.font_name .. " 24",
				},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(10),
					{
						widget = wibox.widget.textbox,
						markup = "<b>Screen:</b><i> " .. generate_string_of_numbers(1, screen.count()) .. "</i>",
						font = beautiful.font_name .. " 13",
					},
					{
						widget = wibox.widget.textbox,
						markup = "<b>Tag:</b><i> " .. generate_string_of_numbers(1, 9) .. "</i>",
						font = beautiful.font_name .. " 13",
					},
					{
						widget = wibox.widget.textbox,
						markup = "<b>Escape</b> to cancel",
						font = beautiful.font_name .. " 13",
					},
				},
			},
		},
	})
end

---@param focused_screen Screen
---@param logic ScreenSwitcherLogic
local function generate_focused_screen_content(focused_screen, logic)
	local screen_prompt_widget = wibox.widget({
		widget = wibox.widget.textbox,
		halign = "center",
		valign = "center",
		markup = "<b>Screen:</b> ",
		font = beautiful.font_name .. "24",
	})

	local screen_prompt_answer_widget = wibox.widget({
		widget = wibox.widget.textbox,
		halign = "center",
		valign = "center",
		text = "_",
		font = beautiful.font_name .. "24",
	})

	local tag_prompt_widget = wibox.widget({
		widget = wibox.widget.textbox,
		halign = "center",
		valign = "center",
		markup = "<b>Tag:</b> ",
		font = beautiful.font_name .. "24",
	})

	local tag_answer_widget = wibox.widget({
		widget = wibox.widget.textbox,
		halign = "center",
		valign = "center",
		text = "_",
		font = beautiful.font_name .. "24",
	})

	logic.register_screen_callback(function(new_index)
		print("updating widget with value " .. new_index)
		screen_prompt_answer_widget.text = new_index
	end)

	logic.register_tag_callback(function(new_index)
		tag_prompt_widget.text = new_index
	end)

	return wibox.widget({
		widget = wibox.container.place,
		point = function(geo, args)
			return {
				x = (args.parent.width / 2) - geo.width / 2,
				y = (args.parent.height / 2) - geo.height / 2,
			}
		end,
		valign = "center",
		halign = "center",
		{
			widget = wibox.container.background,
			bg = theme.bg_color,
			forced_width = dpi(300),
			forced_height = dpi(300),
			shape = ui_utils.rrect(5),
			{
				widget = wibox.container.margin,
				margins = theme.box_margin,
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(40),
					spacing_widget = wibox.widget.separator,
					{
						widget = wibox.widget.textbox,
						text = "Switch",
						valign = "center",
						halign = "center",
						font = beautiful.font .. " 34",
					},
					{
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(20),
						{
							layout = wibox.layout.align.horizontal,
							expand = "inside",
							screen_prompt_widget,
							nil,
							screen_prompt_answer_widget,
						},
						{
							layout = wibox.layout.align.horizontal,
							expand = "inside",
							tag_prompt_widget,
							nil,
							tag_answer_widget,
						},
					},
				},
			},
		},
	})
end

awful.screen.connect_for_each_screen(function(s)
	create_popup_for_screen(s)
end)

---@param logic ScreenSwitcherLogic
M.setup = function(logic)
	logic.register_keygrabber_stop_callback(function(user_input)
		if user_input ~= nil then
			logic.move_focused_client_to(user_input.screen_index, user_input.tag_index)
		end
		for entry in screen do
			attached_popups[entry.index].popup.visible = false
		end
	end)
end

---@param logic ScreenSwitcherLogic
M.start = function(logic)
	local focused_screen = awful.screen.focused()

	for entry in screen do
		if entry.index == focused_screen.index then
			local focused_screen_content = generate_focused_screen_content(entry, logic)
			-- TODO Decide if popups should generate help boxes or no
			-- local help_box = generate_help_box()
			attached_popups[entry.index].set_content({ focused_screen_content })
		else
			attached_popups[entry.index].set_content({ generate_screen_index(entry) })
		end

		attached_popups[entry.index].popup.visible = true
	end

	local user_input = logic.capture_user_input()
end

return M
