---@module "lazy"
---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	version = "v9.1.0",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format buffer",
		},
	},
	---@module "conform.types"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			python = { "ruff" },
		},
		formatters = {
			prettier = {
				prepend_args = { "--prose-wrap", "always" },
			},
		},
		format_after_save = {
			timeout_ms = 10000,
			async = true,
			lsp_format = "fallback",
		}
	},
}
