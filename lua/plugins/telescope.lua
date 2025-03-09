---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = "Telescope",
	keys = {
		{
			"<leader>fc",
			function()
				require("telescope.builtin").find_files({
					cwd = vim.fn.stdpath("config"),
					no_ignore = true,
				})
			end,
			"n",
			"Find files (rooted at neovim config dir).",
		},
		{
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			"n",
			"Find files (root dir).",
		},
		{
			"<leader>lg",
			"<cmd>Telescope live_grep<cr>",
			"n",
			"Live grep (root dir).",
		},
		{
			"<C-p>",
			"<cmd>Telescope git_files<cr>",
			"n",
			"Find files tracked by git.",
		},
		{
			"<leader>lr",
			"<cmd>Telescope lsp_references<cr>",
			"n",
			"List references for symbol under cursor.",
		},
		{
			"<leader>li",
			"<cmd>Telescope lsp_implementations<cr>",
			"n",
			"List implementations for symbol under cursor.",
		},
		{
			"<leader>ls",
			"<cmd>Telescope lsp_document_symbols<cr>",
			"n",
			"List all symbols for current buffer.",
		},
		{
			"<leader>lws",
			"<cmd>Telescope lsp_workspace_symbols<cr>",
			"n",
			"List all workspace symbols.",
		},
		{
			"<leader>ld",
			"<cmd>Telescope diagnostics<cr>",
			"n",
			"Show all vim diagnostics.",
		},
	},
}
