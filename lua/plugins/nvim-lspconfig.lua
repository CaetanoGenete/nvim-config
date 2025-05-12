---@module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"williamboman/mason-lspconfig.nvim",
		version = "v2.0.0",
		dependencies = { "williamboman/mason.nvim" },
		lazy = true,
		opts = {
			-- NOTE: language servers defined by user config must be installed manually or through mason
			ensure_installed = { "lua_ls" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		version = "v2.1.0",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
		},
	},
}
