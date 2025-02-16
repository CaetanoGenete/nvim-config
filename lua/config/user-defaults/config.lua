--- This module provides default configs for user-settings

local M = {}
local user_settings = require("utils.module").require_or("config.user.config", {})

--- Language servers which are installed and configured by default.
M.default_language_servers = { "lua_ls" }

--- The language servers to be attached and configured.
M.language_servers = require("utils.set"):new()
M.language_servers:insert_range(M.default_language_servers)
M.language_servers:insert_range(user_settings.language_servers)

--- @param language string
--- @return boolean
M.ls_enabled = function(language)
	return M.language_servers:has(language)
end

return M
