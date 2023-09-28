local awful = require("awful")
local wibox = require("wibox")
--- @type Theme
local beautiful = require("beautiful")
local ui_utils = require("utils.ui")
local hover_utils = require("utils.hover")

local theme = {
	icon_font = beautiful.icon_font .. 15,
	font_fg = beautiful.fg_normal,
	hover_fg = beautiful.fg_focus,
}

local buttons = {
	awful.button({
		modifiers = {},
		button = 1,
		on_release = function()
			VOLUME_SERVICE.TOGGLE()
		end,
	}),
	awful.button({
		modifiers = {},
		button = 3,
		on_release = function()
			awful.spawn("pavucontrol")
		end,
	}),
	awful.button({
		modifiers = {},
		button = 4,
		on_release = function()
			VOLUME_SERVICE.INCREASE()
		end,
	}),
	awful.button({
		modifiers = {},
		button = 5,
		on_release = function()
			VOLUME_SERVICE.DECREASE()
		end,
	}),
}

local function volume_register_volume_update(icon, text)
	VOLUME_SERVICE.REGISTER_UPDATE_CALLBACK(function(newVolume, isMute, _)
		if isMute then
			icon.text = ""
			text.text = "Muted"
		else
			if newVolume >= 50 then
				icon.text = ""
			elseif newVolume < 50 and newVolume > 0 then
				icon.text = ""
			else
				icon.text = ""
			end
			text.text = newVolume .. "%"
		end
	end)
end

local function create()
	local volume_widget = wibox.widget({
		buttons = buttons,
		widget = wibox.container.background,
		fg = theme.font_fg,
		{
			id = "icon",
			widget = wibox.widget.textbox,
			font = theme.icon_font,
		},
	})

	local tooltip = ui_utils.generate_tooltip(volume_widget, "Click to mute")
	volume_register_volume_update(volume_widget.icon, tooltip)

	hover_utils.apply_hover_effects(volume_widget, {
		hover_utils.cursor("hand1"),
		hover_utils.fg_hover(theme.hover_fg),
	})

	return volume_widget
end

return create
