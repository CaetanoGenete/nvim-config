local M = {}

---Fetches the function declaration node surrounding the cursor, or nil if the
---cursor is not within a function.
---@return TSNode|nil
M.function_node_at_cursor = function()
	local utils = require("nvim-treesitter.ts_utils")
	local node = utils.get_node_at_cursor()

	while node ~= nil do
		if node:type() == "function" then
			return node
		end
		node = node:parent()
	end

	return nil
end

return M
