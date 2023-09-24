local awful = require("awful")

---@class ScreenSwitcherLogic
local M = {}

---@type fun(index: number)[]
local screen_index_callbacks = {}

---@type fun(index: number)[]
local tag_index_callbacks = {}

---@type fun()[]
local ui_close_callback = {}

local function determine_screen_index()
	if screen.count() == 2 then
		if awful.screen.focused().index == 1 then
			return 2
		else
			return 1
		end
	end
	return nil
end

local function notify_callbacks(callbacks, index)
	for _, value in ipairs(callbacks) do
		value(index)
	end
end

---@param callback fun(index: number)
M.register_screen_callback = function(callback)
	table.insert(screen_index_callbacks, callback)
end

---@param callback fun(index: number)
M.register_tag_callback = function(callback)
	table.insert(tag_index_callbacks, callback)
end
--
---@param callback fun(screen_index: number|nil, tag_index: number|nil)
M.register_keygrabber_stop_callback = function(callback)
	table.insert(ui_close_callback, callback)
end

M.capture_user_input = function()
	local parsed_input = {
		screen_index = nil,
		tag_index = nil,
	}

	local key_grabber = awful.keygrabber({
		start_callback = function()
			parsed_input.screen_index = determine_screen_index()
			if parsed_input.screen_index ~= nil then
				notify_callbacks(screen_index_callbacks, parsed_input.screen_index)
			end
		end,
		stop_callback = function()
			notify_callbacks(ui_close_callback, parsed_input)
		end,
		stop_key = "Escape",
		keypressed_callback = function(grabber, mod, key, sequence)
			if parsed_input.screen_index == nil then
				parsed_input.screen_index = tonumber(key)
				notify_callbacks(screen_index_callbacks, parsed_input.screen_index)
				return
			end

			parsed_input.tag_index = tonumber(key)
			notify_callbacks(tag_index_callbacks, parsed_input.screen_index)
			grabber:stop()
		end,
	})

	key_grabber:start()

	return parsed_input
end

return M
