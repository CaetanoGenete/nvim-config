return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Add rounded border to hover window
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	end,
}
