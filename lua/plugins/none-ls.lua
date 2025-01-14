local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

---@param client vim.lsp.Client
---@param bufnr integer
local function format_on_save_callback(client, bufnr)
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

---@module "lazy"
---@type LazyPluginSpec
return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local nonels = require("null-ls")
		nonels.setup({
			sources = {
				-- golang
				nonels.builtins.diagnostics.golangci_lint,
				nonels.builtins.formatting.gofumpt,
				nonels.builtins.formatting.goimports_reviser,
				-- lua
				nonels.builtins.formatting.stylua,
			},
			on_attach = format_on_save_callback,
		})
	end,
}
