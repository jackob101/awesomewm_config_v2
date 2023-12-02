local gears = require("gears")
local awful = require("awful")

local INC_VOLUME_CMD = "pw-volume change '+5%'"
local DEC_VOLUME_CMD = "pw-volume change '-5%'"
local TOG_VOLUME_CMD = "pw-volume mute toggle"

---@class VolumeService
local M = {}

-- This is soo stupid but it works
M._canServe = true

---@type fun(newVolume:number, isMute: boolean, shouldDisplay: boolean)[]
M._registered_update_callbacks = {}

---@param callback fun(newVolume:number, isMute: boolean, shouldDisplay: boolean)
function M.REGISTER_UPDATE_CALLBACK(callback)
	for _, entry in pairs(M._registered_update_callbacks) do
		if entry == callback then
			return false
		end
	end

	table.insert(M._registered_update_callbacks, callback)
end

---@param shouldDisplay boolean?
function M.UPDATE(shouldDisplay)
	awful.spawn.easy_async_with_shell("pw-volume status | jq '.percentage' | xargs", function(out)
		-- local isMute = string.match(out, "%[(o%D%D?)%]") == "off" -- \[(o\D\D?)\] - [on] or [off]
		-- local newVolume = tonumber(string.match(out, "(%d?%d?%d)%%")) or 0
		local shouldDisplay = shouldDisplay or false
	
		local isMute = string.match(out, "null") 
		print("Is mute")
		print(tostring(isMute))
		local newVolume

		if isMute then
			newVolume = 0
		else 
			print('Out output')
			print(out)
			newVolume = tonumber(out)
		end

		for _, entry in pairs(M._registered_update_callbacks) do
			entry(newVolume, isMute, shouldDisplay)
		end

		M._canServe = true
	end)
end

---@param shouldDisplay boolean?
function M.INCREASE(shouldDisplay)
	if M._canServe then
		M._canServe = false
		awful.spawn.easy_async_with_shell(INC_VOLUME_CMD, function()
			M.UPDATE(shouldDisplay)
		end)
		return true
	end
	return false
end

---@param shouldDisplay boolean?
function M.DECREASE(shouldDisplay)
	if M._canServe then
		M._canServe = false
		awful.spawn.easy_async_with_shell(DEC_VOLUME_CMD, function()
			M.UPDATE(shouldDisplay)
		end)
		return true
	end
	return false
end

---@param shouldDisplay boolean?
function M.TOGGLE(shouldDisplay)
	if M._canServe then
		M._canServe = false
		awful.spawn.easy_async_with_shell(TOG_VOLUME_CMD, function()
			M.UPDATE(shouldDisplay)
		end)
		return true
	end
	return false
end

--- @param amount number Amount to set volume to
function M.SET(amount, shouldDisplay)
	if M._canServe then
		if amount and type(amount) == "number" then
			if amount >= 0 and amount <= 100 then
				M._canServe = false
				awful.spawn.easy_async_with_shell("amixer -D pulse sset Master " .. amount .. "%", function()
					M.UPDATE(shouldDisplay)
				end)
				return true
			end
		end
	end
	return false
end

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		M.UPDATE(false)
	end,
})

return M
