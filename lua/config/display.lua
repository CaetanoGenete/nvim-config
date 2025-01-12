--- Configuration for neovim visuals

vim.o.termguicolors = true
vim.o.colorcolumn = "120"

-- Add rounded border to hover window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
