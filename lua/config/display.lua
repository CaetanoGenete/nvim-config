--- Configuration for neovim visuals

BORDER_STYLE = "rounded"

vim.o.termguicolors = true
vim.o.colorcolumn = "120"

-- Add rounded border to hover window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = BORDER_STYLE })

-- Add rounded border to diagonstics float
vim.diagnostic.config({
	float = { border = BORDER_STYLE },
})
