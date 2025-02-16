---@class Set Stores unique values
---@field elems table<any, boolean> The internal representation of the set
local Set = {}
Set.__index = Set

---@param init any[]? Initial list of elements
---@return Set
function Set:new(init)
	local result = setmetatable({ elems = {} }, Set)
	result:insert_range(init or {})
	return result
end

---@param elem any Element to add to the set.
function Set:insert(elem)
	self.elems[elem] = true
end

---@param elems any[] Range of elements to add to the set
function Set:insert_range(elems)
	for _, value in ipairs(elems) do
		self:insert(value)
	end
end

---@param elem any Element to query for existance within the set
function Set:has(elem)
	return self.elems[elem] or false
end

function Set:to_list()
	---@type any[]
	local result = {}
	for value, _ in pairs(self.elems) do
		table.insert(result, value)
	end
	return result
end

return Set
