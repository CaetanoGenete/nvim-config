local M = {}

---Checks for existance of `module`.
---
---If found, also preloads the module.
---@param module string module to query for existance.
---@return boolean
M.module_exists = function(module)
	if package.loaded[module] then
		return true
	end

	---@diagnostic disable-next-line: deprecated
	for _, searcher in ipairs(package.searchers or package.loaders) do
		local loader = searcher(module)
		if type(loader) == "function" then
			package.preload[module] = loader
			return true
		end
	end

	return false
end

return M
