---@module "lazy"
---@type LazyPluginSpec
return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local nonels = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		nonels.setup({
			sources = {
				-- golang
				nonels.builtins.diagnostics.golangci_lint,
				nonels.builtins.formatting.gofumpt,
				nonels.builtins.formatting.goimports_reviser,
				-- lua
				nonels.builtins.formatting.stylua,
			},
			-- format on save
			on_attach = function(client, bufnr)
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
			end,
		})
	end,
}
