require("nvim-treesitter").install { "lua" }
vim.treesitter.start()

vim.lsp.enable("lua_ls")
