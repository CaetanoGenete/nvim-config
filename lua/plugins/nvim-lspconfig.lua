-- Sets up LSP configuration for each enabled language server
--
-- To enable a language server:
-- - In `user.config` add the name of the lsp to the `language_servers` table
-- - (Optional) In the `user/lsp` directory, create a lua module with the same name as the language server (e.g
--   clangd.lua) and return a table of all the settings to be passed to its `setup` function.

local log = require("utils.log")
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
			local setup_format_on_save = require("utils.format_on_save").setup_format_on_save

			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				on_attach = setup_format_on_save,
			})

			local ignore = {
				-- Will be configured using nvim-jdtls to provide extended capabilities. See [ftplugin.java.lua]
				jdtls = true,
			}

			for lsp_name, _ in pairs(user_config.language_servers) do
				if not ignore[lsp_name] then
					local default_ok, default_lang_settings = pcall(require, "config.user-defaults.lsp." .. lsp_name)
					if not default_ok then
						default_lang_settings = {}
					end

					local user_ok, user_lang_settings = pcall(require, "user.lsp." .. lsp_name)
					if not user_ok then
						user_lang_settings = {}
					end

					log.fmt_debug("Setting up: %s. default-config: %s, user-config: %s", lsp_name, default_ok, user_ok)

					lspconfig[lsp_name].setup(vim.tbl_deep_extend("force", default_lang_settings, user_lang_settings))
				end
			end
		end,
	},
}
