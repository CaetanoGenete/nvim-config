--- This module provides default configs for user-settings

DEFAULT_LANGUAGE_SERVERS = { "lua_ls" }

---@module "config.user-defaults.types"
---@type UserSettings
local user_settings = require("utils.module").require_or("config.user.config", {})

local M = {
	--- The language servers to be attached and configured.
	language_servers = require("utils.set"):new({
		unpack(DEFAULT_LANGUAGE_SERVERS),
		unpack(user_settings.language_servers or DEFAULT_LANGUAGE_SERVERS),
	}),
	formatters_by_ft = user_settings.formatters_by_ft,
	linters_by_ft = user_settings.linters_by_ft or {},
}

--- @param language string
--- @return boolean
M.ls_enabled = function(language)
	return M.language_servers:has(language)
end

return M
