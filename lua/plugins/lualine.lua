---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		theme = "iceberg_dark",
	},
}
