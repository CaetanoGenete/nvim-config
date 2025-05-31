return {
	---@param client vim.lsp.Client
	on_attach = function(client, _)
		-- Assuming another lSP is providing hover information
		client.server_capabilities.hoverProvider = false
	end,
}
