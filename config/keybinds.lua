--- @type Awful
local awful = require("awful")

local hotkeys_popup = require("awful.hotkeys_popup")

-- General Awesome keys
awful.keyboard.append_global_keybindings({

	-- Awesome

	awful.key({
		modifiers = { MODKEY },
		key = "F1",
		description = "show help",
		group = "awesome",
		on_press = hotkeys_popup.show_help,
	}),
	awful.key({
		modifiers = { MODKEY, "Control" },
		key = "r",
		description = "reload awesome",
		group = "awesome",
		on_press = awesome.restart,
	}),

	-- Launcher

	awful.key({
		modifiers = { MODKEY },
		key = "Return",
		description = "open a terminal",
		group = "launcher",
		on_press = function()
			awful.spawn(TERMINAL)
		end,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "d",
		description = "Start application",
		group = "launcher",
		on_press = function()
			awful.spawn(os.getenv("HOME") .. "/.config/rofi/launcher.sh")
		end,
	}),
	awful.key({
		modifiers = {},
		key = "Print",
		description = "Screenshoot",
		group = "launcher",
		on_press = function()
			awful.spawn("flameshot gui")
		end,
	}),

	-- Tag

	awful.key({
		modifiers = { MODKEY },
		key = "Left",
		description = "view previous",
		group = "tag",
		on_press = awful.tag.viewprev,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "Right",
		description = "view next",
		group = "tag",
		on_press = awful.tag.viewnext,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "Escape",
		description = "go back",
		group = "tag",
		on_press = awful.tag.history.restore,
	}),

	-- Screen

	awful.key({
		modifiers = { MODKEY, "Control" },
		key = "l",
		on_press = function()
			awful.screen.focus_relative(1)
		end,
		description = "focus the next screen",
		group = "screen",
	}),
	awful.key({
		modifiers = { MODKEY, "Control" },
		key = "h",
		description = "focus the previous screen",
		group = "screen",
		on_press = function()
			awful.screen.focus_relative(-1)
		end,
	}),

	-- Client

	awful.key({
		modifiers = { MODKEY, "Control" },
		key = "n",
		description = "restore minimized",
		group = "client",
		on_press = function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:activate({ raise = true, context = "key.unminimize" })
			end
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Shift" },
		key = "j",
		on_press = function()
			awful.client.swap.byidx(1)
		end,
		description = "swap with next client by index",
		group = "client",
	}),
	awful.key({
		modifiers = { MODKEY, "Shift" },
		key = "k",
		description = "swap with previous client by index",
		group = "client",
		on_press = function()
			awful.client.swap.byidx(-1)
		end,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "u",
		description = "jump to urgent client",
		group = "client",
		on_press = awful.client.urgent.jumpto,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "j",
		description = "focus next by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(1)
		end,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "k",
		description = "focus previous by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(-1)
		end,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "Tab",
		description = "go back",
		group = "client",
		on_press = function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
	}),

	-- Layout

	awful.key({
		modifiers = { MODKEY },
		key = "l",
		description = "increase master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(0.05)
		end,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "h",
		description = "decrease master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(-0.05)
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Shift" },
		key = "h",
		description = "increase the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Shift" },
		key = "l",
		description = "decrease the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(-1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Control" },
		key = "h",
		description = "increase the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incncol(1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Control" },
		key = "l",
		description = "decrease the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incncol(-1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { MODKEY },
		key = "space",
		description = "select next",
		group = "layout",
		on_press = function()
			awful.layout.inc(1)
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Shift" },
		key = "space",
		description = "select previous",
		group = "layout",
		on_press = function()
			awful.layout.inc(-1)
		end,
	}),
	awful.key({
		modifiers = { MODKEY },
		keygroup = "numpad",
		description = "select layout directly",
		group = "layout",
		on_press = function(index)
			local t = awful.screen.focused().selected_tag
			if t then
				t.layout = t.layouts[index] or t.layout
			end
		end,
	}),

	-- Tag

	awful.key({
		modifiers = { MODKEY },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Control" },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Shift" },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { MODKEY, "Control", "Shift" },
		keygroup = "numrow",
		description = "toggle focused client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),

	-- Volume

	awful.key({
		modifiers = {},
		key = "XF86AudioRaiseVolume",
		on_press = function()
			VOLUME_SERVICE.INCREASE(true)
		end,
		description = "Increase volume",
		group = "audio",
	}),
	awful.key({
		modifiers = {},
		key = "XF86AudioLowerVolume",
		on_press = function()
			VOLUME_SERVICE.DECREASE(true)
		end,
		description = "Decrease volume",
		group = "audio",
	}),
	awful.key({
		modifiers = {},
		key = "XF86AudioMute",
		on_press = function()
			VOLUME_SERVICE.TOGGLE(true)
		end,
		description = "Mute audio",
		group = "audio",
	}),
})

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({
			modifiers = { MODKEY },
			key = "f",
			on_press = function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end,
			description = "toggle fullscreen",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY, "Shift" },
			key = "q",
			on_press = function(c)
				c:kill()
			end,
			description = "Close focused application",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY, "Control" },
			key = "space",
			on_press = awful.client.floating.toggle,
			description = "toggle floating",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY, "Control" },
			key = "Return",
			on_press = function(c)
				c:swap(awful.client.getmaster())
			end,
			description = "move to master",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY },
			key = "o",
			on_press = function(c)
				c:move_to_screen()
			end,
			description = "move to screen",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY },
			key = "t",
			on_press = function(c)
				c.ontop = not c.ontop
			end,
			description = "toggle keep on top",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY },
			key = "n",
			on_press = function(c)
				-- The client currently has the input focus, so it cannot be
				-- minimized, since minimized clients can't have the focus.
				c.minimized = true
			end,
			description = "minimize",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY },
			key = "m",
			on_press = function(c)
				c.maximized = not c.maximized
				c:raise()
			end,
			description = "(un)maximize",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY, "Control" },
			key = "m",
			on_press = function(c)
				c.maximized_vertical = not c.maximized_vertical
				c:raise()
			end,
			description = "(un)maximize vertically",
			group = "client",
		}),
		awful.key({
			modifiers = { MODKEY, "Shift" },
			key = "m",
			on_press = function(c)
				c.maximized_horizontal = not c.maximized_horizontal
				c:raise()
			end,
			description = "(un)maximize horizontally",
			group = "client",
		}),
	})
end)

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
		end),
		awful.button({ MODKEY }, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({ MODKEY }, 3, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.resize(c)
		end),
	})
end)
