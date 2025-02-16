-- Sets up LSP configuration for each enabled language server
--
-- To enable a language server:
-- - In `user.config` add the name of the lsp to the `language_servers` table
-- - (Optional) In the `user/lsp` directory, create a lua module with the same name as the language server (e.g
--   clangd.lua) and return a table of all the settings to be passed to its `setup` function.

local user_config = require("config.user-defaults.config")

---@module "lazy"
---@type LazyPluginSpec[]
return {
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		opts = {
			-- NOTE: language servers defined by user config must be installed manually or through mason
			ensure_installed = user_config.default_language_servers,
		},
		-- NOTE: Language servers must be setup **after** mason-lspconfig, hence:
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			local lspconfig = require("lspconfig")
			local log = require("utils.log")

			lspconfig.util.default_config = vim.tbl_extend(
				"force",
				lspconfig.util.default_config,
				{ on_attach = require("utils.format_on_save").setup_format_on_save }
			)

			local ignore = {
				jdtls = true, -- Will be configured using nvim-jdtls. See [ftplugin.java.lua]
			}

			for ls_name, _ in pairs(user_config.language_servers.elems) do
				if not ignore[ls_name] then
					log.fmt_debug("Configuring '%s' LS", ls_name)

					lspconfig[ls_name].setup(
						vim.tbl_deep_extend(
							"force",
							require("utils.module").require_or("config.user-defaults.lsp." .. ls_name, {}),
							require("utils.module").require_or("user.lsp." .. ls_name, {})
						)
					)
				end
			end
		end,
	},
}
