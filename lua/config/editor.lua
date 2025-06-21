--- Basic look of the editor, e.g. tab size and wrapping.

BORDER_STYLE = "rounded"

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = false
vim.o.colorcolumn = "120"
vim.o.signcolumn = "yes:1"
vim.wo.relativenumber = true

--- Code folding

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

--- Boxes

-- HACK: Until Telescope and plenary resolve the vim.winborder issue
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({ border = BORDER_STYLE })
end)

vim.diagnostic.config({
	virtual_text = true,
	float = { border = BORDER_STYLE },
})

--- Netrw

vim.g.netrw_bufsettings = "noma nomod nonu nobl nowrap ro"

--- Symbols

local sign = vim.fn.sign_define
sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
sign("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
