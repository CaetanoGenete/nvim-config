return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
				-- Using lua_ls primarily for easy nvim configuration
				"lua_ls",
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			-- By default, use capabilties as defined by cmp_nvim_lsp
			lspconfig.util.default_config = vim.tbl_extend(
				"force",
				lspconfig.util.default_config,
				{ capabilities = require("cmp_nvim_lsp").default_capabilities() }
			)

			local configured_lsps = require("user.config").language_servers
			for _, lsp_name in pairs(configured_lsps) do
				local ok, lang_settings = pcall(require, "user.lsp." .. lsp_name)
				if not ok then
					lang_settings = {}
				end
				lspconfig[lsp_name].setup(lang_settings)
			end
		end,
	},
}
