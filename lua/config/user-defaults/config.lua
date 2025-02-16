--- This module provides default configs for user-settings

local utils = require("utils.set")
local user_settings = require("config.user.config")

local M = {}

--- Language servers which are installed and configured by default.
M.default_language_servers = { "lua_ls" }

--- The language servers to be attached and configured.
--- @type set
M.language_servers = {}
utils.setadd(M.language_servers, M.default_language_servers)
utils.setadd(M.language_servers, user_settings.language_servers)

--- @param language string
--- @return boolean
M.ls_enabled = function(language)
	return M.language_servers[language] or false
end

return M
