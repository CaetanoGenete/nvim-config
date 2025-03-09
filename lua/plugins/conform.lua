vim.api.nvim_create_user_command("AutoFmtToggle", function(args)
	if args.bang then
		vim.b.disable_autoformat = not (vim.b.disable_autoformat or false)
	else
		vim.g.disable_autoformat = not (vim.g.disable_autoformat or false)
	end
end, {
	desc = "Toggle autoformat-on-save. If suffixed with a bang (!), will toggle only for the current buffer.",
	bang = true,
})

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
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,
	},
}
