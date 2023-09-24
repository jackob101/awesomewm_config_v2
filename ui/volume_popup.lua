local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local ui_utils = require("ui_utils")
---@type Theme
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local theme = {
	slider_background_color = beautiful.bg_minimize,
	active_slider_background_color = beautiful.fg_normal,
	text_color = beautiful.fg_normal,
	popup_background_color = beautiful.bg_normal .. "EE",
}

local logic = {
	---Register mouse events to prevent windget from disapearing when hovered
	---@param overlay Widget
	connect_signals = function(overlay)
		overlay:connect_signal("mouse::enter", function()
			overlay.timer:stop()
		end)

		overlay:connect_signal("mouse::leave", function()
			overlay.timer:again()
		end)
	end,

	--- Registers callback in VolumeService
	---@param volume_slider Widget
	---@param icon_widget Widget
	register_update_callback = function(volume_slider, icon_widget)
		VOLUME_SERVICE.REGISTER_UPDATE_CALLBACK(function(newVolume, isMute, shouldDisplay)
			volume_slider:set_value(newVolume)

			if isMute then
				icon_widget.text = ""
			else
				if newVolume >= 50 then
					icon_widget.text = ""
				elseif newVolume < 50 and newVolume > 0 then
					icon_widget.text = ""
				else
					icon_widget.text = ""
				end
			end

			if shouldDisplay then
				local overlay = awful.screen.focused().volume_popup_widget
				overlay.visible = true
				overlay.timer:again()
			end
		end)
	end,
}

local icon_widget = wibox.widget({
	widget = wibox.widget.textbox,
	text = "",
	valign = "center",
	halign = "center",
	font = beautiful.icon_font .. 150,
})

local volume_slider = wibox.widget({
	id = "volume_slider",
	button = {},
	maximum = 100,
	minimum = 0,
	widget = wibox.widget.slider,
	bar_handle_color = beautiful.fg_focus,
	bar_shape = ui_utils.rrect(5),
	bar_height = dpi(10),
	bar_color = theme.slider_background_color,
	bar_active_color = theme.active_slider_background_color,
	handle_color = theme.slider_handle_color,
	handle_shape = gears.shape.circle,
	handle_width = dpi(0),
	handle_border_width = 0,
})

--- @param s Screen
local function create(s)
	local overlay = awful.popup({
		ontop = true,
		visible = false,
		type = "notification",
		bg = "#00000000",
		screen = s,
		widget = {
			widget = wibox.container.background,
			bg = theme.popup_background_color,
			shape = ui_utils.rrect(dpi(5)),
			forced_width = dpi(300),
			forced_height = dpi(300),
			{
				left = dpi(24),
				right = dpi(24),
				top = dpi(14),
				bottom = dpi(14),
				widget = wibox.container.margin,
				{
					layout = wibox.layout.fixed.vertical,
					{
						widget = wibox.container.background,
						fg = theme.text_color,
						icon_widget,
					},
					volume_slider,
				},
			},
		},
	})

	awful.placement.bottom(overlay, {
		honor_workarea = true,
		offset = {
			x = -160,
			y = -340,
		},
	})

	overlay.timer = gears.timer({
		timeout = 2,
		autostart = false,
		single_shot = true,
		callback = function()
			overlay.visible = false
		end,
	})

	s.volume_popup_widget = overlay

	logic.connect_signals(overlay)
	logic.register_update_callback(volume_slider, icon_widget)

	return overlay
end

awful.screen.connect_for_each_screen(function(s)
	create(s)
end)
