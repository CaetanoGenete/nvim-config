require("nvim-treesitter").install { "python" }
vim.treesitter.start()

vim.lsp.enable("basedpyright")
vim.lsp.enable("ruff")
