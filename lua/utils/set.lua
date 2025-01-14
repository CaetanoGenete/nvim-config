function Fromset(set)
	local result = {}
	for value, _ in pairs(set) do
		table.insert(result, value)
	end
	return result
end

function Setadd(set, list)
	for _, value in ipairs(list) do
		set[value] = true
	end
end
