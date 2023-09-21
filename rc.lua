-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)
-- }}}
--
CONFIG_DIR_PATH = os.getenv("HOME") .. "/.config/awesome_new/"

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(CONFIG_DIR_PATH .. "theme.lua")

-- This is used later as the default terminal and editor to run.
TERMINAL = "kitty"
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = TERMINAL .. " -e " .. editor

-- Menubar configuration
menubar.utils.TERMINAL = TERMINAL -- Set the terminal for applications that require it

MODKEY = "Mod4"
--
--
require("service")
require("signals")
require("config/keybinds")
require("config/rules")
require("config/wallpaper")
require("ui/statusbar")
require("ui/volume_popup")

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.spiral,
		awful.layout.suit.tile,
	})
end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()
--
-- -- Create a textclock widget
-- mytextclock = wibox.widget.textclock()
--
screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag({ "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" }, s, awful.layout.layouts[1])
end)

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
	awful.button({}, 4, awful.tag.viewprev),
	awful.button({}, 5, awful.tag.viewnext),
})
-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)

require("config/autostart")
awesome.emit_signal(Signals.volume_update_widgets, 100, false, false)
