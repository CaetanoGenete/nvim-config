M = {}

---@alias set table<any, boolean>

---Accepts a set as argument and returns copy of its elements in a list
---
---@param set set
---@return any[]
M.fromset = function(set)
	---@type any[]
	local result = {}
	for value, _ in pairs(set) do
		table.insert(result, value)
	end
	return result
end

---Inserts all elements of `list` into `set`, maintaining the uniqueness property of `set`.
---
---@param set set
---@param list any[]
M.setadd = function(set, list)
	for _, value in ipairs(list) do
		set[value] = true
	end
end

return M
