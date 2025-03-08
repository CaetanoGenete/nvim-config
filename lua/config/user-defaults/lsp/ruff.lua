---@param client vim.lsp.Client
local function on_attach(client, _)
	-- Assuming another lSP is providing hover information
	client.server_capabilities.hoverProvider = false
end

return { on_attach = on_attach }
