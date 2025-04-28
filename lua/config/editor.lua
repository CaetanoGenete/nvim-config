--- Basic look of the editor, e.g. tab size and wrapping.

BORDER_STYLE = "rounded"

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = false
vim.o.colorcolumn = "120"

vim.wo.relativenumber = true

-- HACK: Until Telescope and plenary resolve the vim.winborder issue
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({ border = BORDER_STYLE })
end)

vim.diagnostic.config({
	virtual_text = true,
	float = { border = BORDER_STYLE },
})
