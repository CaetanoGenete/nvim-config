local M = {}

---Attempts to load `module`, otherwise returns `default`.
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
