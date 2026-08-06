---@module "lazy"
---@type LazyPluginSpec
return {
	"catppuccin/nvim",
	name = "catppuccin",
	version = "v2.0.0",
	priority = 1000,
	opts = {
		flavor = "mocha",
		term_colors = true,
		no_italic = true,
		transparent_background = true,
		float = {
			transparent = true,
			solid = true
		}
	},
}
