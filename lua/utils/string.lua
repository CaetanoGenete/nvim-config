local M = {}

--- Splits a string by `sep`.
---@param str string
---@param sep? string defaults to " "
---@return string[]
---@nodiscard
M.split = function(str, sep)
	if sep == nil then
		sep = " "
	end

	---@type string[]
	local result = {}

	local start = 1
	while true do
		local idx = str:find(sep, start)
		if idx == nil then
			break
		end

		table.insert(result, str:sub(start, idx))
		start = idx + 1
	end

	return result
end

return M
