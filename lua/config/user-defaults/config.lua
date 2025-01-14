---This module provides default configs for user-settings

require("utils.set")

local M = {}

local user_settings = require("config.user.config")

M.language_servers = {}
Setadd(M.language_servers, { "lua_ls" })
Setadd(M.language_servers, user_settings.language_servers)

return M
