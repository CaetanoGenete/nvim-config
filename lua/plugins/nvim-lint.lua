---@module "lazy"
---@type LazyPluginSpec
return {
	"mfussenegger/nvim-lint",
	commit = "b47cbb249351873e3a571751c3fb66ed6369852f",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = require("utils.module").require_or("user.linters", {})

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
