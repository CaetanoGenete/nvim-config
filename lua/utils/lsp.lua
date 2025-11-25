local M = {}

--- Checks to see if the LSP named `lsp_name` is enabled.
---
--- *Dev note*: This acts as a proxy to the `vim.lsp` API just in case there are changes.
--- @param lsp_name string The name of the LSP to query.
function M.lsp_enabled(lsp_name)
	return vim.lsp._enabled_configs[lsp_name] ~= nil
end

return M
