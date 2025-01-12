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
		vim.keymap.set(
			"n",
			"<leader>ff",
			builtin.find_files,
			{ desc = "Use telescope to view (and select) all files from the current working directory." }
		)
		vim.keymap.set(
			"n",
			"<C-p>",
			builtin.git_files,
			{ desc = "Use telescope to view (and select) all files managed by git." }
		)
		vim.keymap.set(
			"n",
			"<leader>lr",
			builtin.lsp_references,
			{ desc = "List all references of the symbol under the cursor" }
		)
		vim.keymap.set(
			"n",
			"<leader>li",
			builtin.lsp_implementations,
			{ desc = "List all implementations of the symbol under the cursor." }
		)
		vim.keymap.set(
			"n",
			"<leader>ds",
			builtin.lsp_document_symbols,
			{ desc = "Lists all symbols of the current document." }
		)
		vim.keymap.set(
			"n",
			"<leader>ws",
			builtin.lsp_workspace_symbols,
			{ desc = "Lists all symbols of the current workspace." }
		)
		vim.keymap.set(
			"n",
			"<leader>vd",
			builtin.diagnostics,
			{ desc = "List all diagnostics (info and error messages)" }
		)
	end,
}
