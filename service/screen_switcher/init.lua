local awful = require("awful")

local logic = require("service.screen_switcher.logic")
local ui = require("service.screen_switcher.ui")

ui.setup(logic)

local M = {}

function M.START()
	ui.start(logic)
end

return M
