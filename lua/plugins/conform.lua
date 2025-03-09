---@module "lazy"
---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	---@module "conform.types"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = require("config.user-defaults.config").formatters_by_ft,
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
