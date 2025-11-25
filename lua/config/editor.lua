--- Basic look of the editor, e.g. tab size and wrapping.

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = false
vim.o.colorcolumn = "+1"
vim.o.signcolumn = "yes:1"
vim.wo.relativenumber = true
vim.o.winborder = "rounded"

--- Code folding

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

--- Boxes

vim.diagnostic.config({ virtual_text = true })

--- Symbols

local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign(
	"DapBreakpointCondition",
	{ text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
)
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
sign(
	"DapStopped",
	{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
)
