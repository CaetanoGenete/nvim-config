-- Loads mason plugins and sets up LSP configuration for each enabled language server
--
-- To enable a language server:
-- - In `user.config` add the name of the lsp to the `language_servers` table
-- - (Optional) In the `user/lsp` directory create a lua module with the same name as the language server (e.g
--   clangd.lua) and return a table of all the settings to be passed to its `setup` function.

local user_config = require("config.user-defaults.config")

---@module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"neovim/nvim-lspconfig",
	},
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
			local cmp_nvim = require("cmp_nvim_lsp")

			-- By default, use capabilties as defined by cmp_nvim_lsp
			lspconfig.util.default_config = vim.tbl_extend(
				"force",
				lspconfig.util.default_config,
				{ capabilities = cmp_nvim.default_capabilities() }
			)

			local ignore = {
				jdtls = true, -- Will be configured using nvim-jdtls to provide extended capabilities
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

					lspconfig[lsp_name].setup(vim.tbl_extend("force", default_lang_settings, user_lang_settings))
				end
			end
		end,
	},
}
