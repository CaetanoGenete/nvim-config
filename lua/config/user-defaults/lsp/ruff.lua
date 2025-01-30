local setup_format_on_save = require("utils.format_on_save").setup_format_on_save

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
	-- Assuming another lSP is providing hover information
	client.server_capabilities.hoverProvider = false
	setup_format_on_save(client, bufnr)
end

return {
	on_attach = on_attach,
	init_options = {
		settings = {
			logLevel = "debug",
		},
	},
}
