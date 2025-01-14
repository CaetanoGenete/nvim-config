---This module provides default configs for user-settings

local utils = require("utils.set")
local user_settings = require("config.user.config")

local M = {}

M.default_language_servers = { "lua_ls" }

--- The language servers to be attached and configured.
M.language_servers = {}
utils.setadd(M.language_servers, M.default_language_servers)
utils.setadd(M.language_servers, user_settings.language_servers)

return M
