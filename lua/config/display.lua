--- Configuration for neovim visuals

vim.o.termguicolors = true
vim.o.colorcolumn = "120"

local _border_style = "rounded"

-- Add rounded border to hover window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = _border_style })

vim.diagnostic.config({
	float = { border = _border_style },
})
