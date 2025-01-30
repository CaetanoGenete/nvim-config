local setup_format_on_save = require("utils.format_on_save").setup_format_on_save

---@module "lazy"
---@type LazyPluginSpec
return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local nonels = require("null-ls")
		nonels.setup({
			on_attach = setup_format_on_save,
			sources = {
				-- golang
				nonels.builtins.diagnostics.golangci_lint,
				nonels.builtins.formatting.gofumpt,
				nonels.builtins.formatting.goimports_reviser,
				-- lua
				nonels.builtins.formatting.stylua,
			},
		})
	end,
}
