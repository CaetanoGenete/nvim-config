---@module "lazy"
---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
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
