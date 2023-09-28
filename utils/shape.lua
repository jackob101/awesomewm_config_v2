local gears = require("gears")

local M = {}

---@param radius number
function M.rrect(radius)
	return function(cr, width, height)
		return gears.shape.rounded_rect(cr, width, height, radius)
	end
end

---comment
---@param radius number
---@param tl boolean
---@param tr boolean
---@param bl boolean
---@param br boolean
---@return function
function M.prrect(radius, tl, tr, br, bl)
	return function(cr, width, height)
		return gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
	end
end

return M
