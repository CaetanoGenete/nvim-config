---@meta

local M = {}

--- The language servers to be setup
--- @type (string)[]
M.language_servers = {
	"lua_ls",
	"clangd",
	"cmake",
	"gopls",
}

return M
