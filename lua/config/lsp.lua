-- Language servers to enable by default
vim.lsp.enable("lua_ls")

-- LSP actions
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>vf", vim.diagnostic.open_float)
