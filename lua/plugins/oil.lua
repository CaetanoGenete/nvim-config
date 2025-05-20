---@module "lazy"
---@type LazyPluginSpec
return {
	"stevearc/oil.nvim",
	version = "v2.15.0",
	cmd = "Oil",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = false,
		view_options = {
			show_hidden = true,
		},
	},
}
