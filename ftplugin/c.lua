require("nvim-treesitter").install { "c" }
vim.treesitter.start()

vim.lsp.enable("clangd")
