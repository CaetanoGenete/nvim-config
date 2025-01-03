return {
	{
		"williamboman/mason.nvim",
		config = true,
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Add rounded border to hover window
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			-- ? setting nvim-lspconfig and mason as dependencies here to ensure correct setup order.
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
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

			-- LSP setup here

			lspconfig.lua_ls.setup({
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					})
				end,
			})
			lspconfig.clangd.setup({})
			lspconfig.cmake.setup({})
			lspconfig.gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
					},
				},
			})
		end,
	},
}
