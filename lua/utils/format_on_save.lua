local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

--- Sets up auto-command to format (if supported) on saving the buffer with `bufnr` id.
---
--- @param client vim.lsp.Client
--- @param bufnr integer
local function setup_format_on_save(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end
end

return {
	setup_format_on_save = setup_format_on_save,
}
