---@module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = true,
		opts = {
			-- NOTE: language servers defined by user config must be installed manually or through mason
			ensure_installed = { "lua_ls" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
	},
}
