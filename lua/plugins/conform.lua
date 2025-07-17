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
	version = "v9.0.0",
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
		log_level = vim.log.levels.DEBUG,
		formatters_by_ft = require("utils.module").require_or("user.formatters", {}),
		formatters = {
			prettier = {
				prepend_args = { "--prose-wrap", "always" },
			},
			injected = {
				options = {
					lang_to_ft = {
						latex = "tex",
					},
					lang_to_ext = {
						latex = "tex",
					},
				},
			},
		},
		format_after_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			return {
				timeout_ms = 2000,
				lsp_format = "fallback",
				async = true,
			}
		end,
	},
}
