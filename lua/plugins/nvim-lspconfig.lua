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
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		lazy = true,
		opts = {
			-- NOTE: language servers defined by user config must be installed manually or through mason
			ensure_installed = DEFAULT_LANGUAGE_SERVERS,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local log = require("utils.log")

			local ignore = {
				jdtls = true, -- Will be configured using nvim-jdtls. See [ftplugin.java.lua]
			}

			for ls_name, _ in pairs(user_config.language_servers.elems) do
				if not ignore[ls_name] then
					lspconfig[ls_name].setup(
						vim.tbl_deep_extend(
							"force",
							{ capabilities = require("blink.cmp").get_lsp_capabilities() },
							require("utils.module").require_or("config.user-defaults.lsp." .. ls_name, {}),
							require("utils.module").require_or("user.lsp." .. ls_name, {})
						)
					)
				else
					log.fmt_debug("Language server: '%s', in ignore list, skipping configuration.", ls_name)
				end
			end
		end,
	},
}
