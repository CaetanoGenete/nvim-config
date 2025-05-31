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
			desc = "Find files (rooted at neovim config dir).",
		},
		{
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			desc = "Find files (root dir).",
		},
		{
			"<leader>lg",
			"<cmd>Telescope live_grep<cr>",
			desc = "Live grep (root dir).",
		},
		{
			"<C-p>",
			"<cmd>Telescope git_files<cr>",
			desc = "Find files tracked by git.",
		},
		{
			"gs",
			"<cmd>Telescope git_status<cr>",
			desc = "Git status",
		},
		{
			"<leader>lr",
			"<cmd>Telescope lsp_references<cr>",
			desc = "List references of symbol under the cursor.",
		},
		{
			"<leader>li",
			"<cmd>Telescope lsp_implementations<cr>",
			desc = "List implementations for symbol under the cursor.",
		},
		{
			"<leader>ls",
			"<cmd>Telescope lsp_document_symbols<cr>",
			desc = "List all symbols for current buffer.",
		},
		{
			"<leader>lws",
			"<cmd>Telescope lsp_workspace_symbols<cr>",
			desc = "List all workspace symbols.",
		},
		{
			"<leader>ld",
			"<cmd>Telescope diagnostics<cr>",
			desc = "Show all vim diagnostics.",
		},
	},
}
