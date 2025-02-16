--- Special keyboard shortcuts for nvim commands. NOTE: For plugins, prefer defining keymappings where said plugin is
--- configured.

vim.g.mapleader = " "

-- LSP actions
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>vf", vim.diagnostic.open_float)
