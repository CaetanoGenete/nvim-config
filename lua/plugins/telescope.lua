---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local builtin = require("telescope.builtin")

		-- key mappings
		vim.keymap.set("n", "<leader>ff", builtin.find_files)
		vim.keymap.set("n", "<leader>fc", function()
			builtin.find_files({
				cwd = vim.fn.stdpath("config"),
				no_ignore = true,
			})
		end)
		vim.keymap.set("n", "<leader>lg", builtin.live_grep)
		vim.keymap.set("n", "<C-p>", builtin.git_files)
		vim.keymap.set("n", "<leader>lr", builtin.lsp_references)
		vim.keymap.set("n", "<leader>li", builtin.lsp_implementations)
		vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols)
		vim.keymap.set("n", "<leader>lws", builtin.lsp_workspace_symbols)
		vim.keymap.set("n", "<leader>ld", builtin.diagnostics)
	end,
}
