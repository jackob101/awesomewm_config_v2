local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

--- @type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

---@type UiUtils
local ui_utils = require("ui_utils")

local theme = {
	text_font = beautiful.font_name .. beautiful.status_bar.font_size,
	icon_font = beautiful.icon_font .. 15,
	font_fg = beautiful.fg_normal,
	info_areas_spacing = beautiful.status_bar.info_widgets.spacing,
	systray = {
		top_margin = dpi(5),
		bottom_margin = dpi(5),
	},
}

local logic = {
	volume_register_button_press = function(volume_widget)
		volume_widget:connect_signal("button::press", function(_, _, _, b)
			if b == 1 then
				VOLUME_SERVICE.TOGGLE()
			elseif b == 3 then
				awful.spawn("pavucontrol")
			elseif b == 4 then
				VOLUME_SERVICE.INCREASE()
			elseif b == 5 then
				VOLUME_SERVICE.DECREASE()
			end
		end)
	end,

	volume_register_hover_effect = function(volume_widget)
		-- TODO Refactor after Utils are refactored
		local old_cursor, old_wibox
		volume_widget:connect_signal("mouse::enter", function()
			local w = mouse.current_wibox
			old_cursor, old_wibox = w.cursor, w
			w.cursor = "hand1"
		end)
		volume_widget:connect_signal("mouse::leave", function()
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end)
	end,

	volume_register_volume_update = function(volume_icon, volume_text, tooltip)
		VOLUME_SERVICE.REGISTER_UPDATE_CALLBACK(function(newVolume, isMute, _)
			if isMute then
				volume_icon.text = ""
				tooltip.text = "Click to unmute"
				volume_text.text = "Muted"
			else
				if newVolume >= 50 then
					volume_icon.text = ""
				elseif newVolume < 50 and newVolume > 0 then
					volume_icon.text = ""
				else
					volume_icon.text = ""
				end
				tooltip.text = "Click to mute"
				volume_text.text = newVolume .. "%"
			end
		end)
	end,
}

---@return Widget
local function create_clock_widget()
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

---@return Widget
local function create_date_widget()
	local date_widget = wibox.widget({
		widget = wibox.container.background,
		fg = theme.font_fg,
		{
			widget = wibox.widget.textclock,
			format = "%a %b %d",
			font = theme.text_font,
		},
	})

	local date_widget_tooltip = ui_utils.generate_tooltip(date_widget, nil)
	date_widget:connect_signal("mouse::enter", function()
		date_widget_tooltip.text = os.date("%A %B %d %Y")
	end)

	return date_widget
end

---@param s Screen
---@return Widget?
local function create_systray_widget(s)
	if s.index ~= 1 then
		return nil
	end

	return wibox.widget({
		widget = wibox.container.margin,
		top = theme.systray.top_margin,
		bottom = theme.systray.bottom_margin,
		{
			widget = wibox.widget.systray,
			screen = "primary",
		},
	})
end

---@return Widget
local function create_volume_widget()
	local icon = wibox.widget({
		widget = wibox.widget.textbox,
		font = theme.icon_font,
	})

	local volume_widget = wibox.widget({
		widget = wibox.container.background,
		fg = theme.font_fg,
		icon,
	})

	local tooltip = ui_utils.generate_tooltip(volume_widget, "Click to mute")

	logic.volume_register_button_press(volume_widget)
	logic.volume_register_hover_effect(volume_widget)
	logic.volume_register_volume_update(icon, tooltip, tooltip)

	return volume_widget
end

---@param s Screen
---@return Widget
local function generate_ui(s)
	return wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = theme.info_areas_spacing,
		create_volume_widget(),
		create_clock_widget(),
		create_date_widget(),
		create_systray_widget(s),
	})
end

return generate_ui
