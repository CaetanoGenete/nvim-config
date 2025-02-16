local M = {}

--- Attempts to load `module`, otherwise returns `default`.
---@param module string
---@param default any
---@return any
M.require_or = function(module, default)
	local ok, result = pcall(require, module)
	if not ok then
		return default
	end

	return result
end

return M
