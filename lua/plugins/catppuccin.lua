---@module "lazy"
---@type LazyPluginSpec
return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		flavor = "mocha",
		term_colors = true,
		no_italic = true,
		color_overrides = {
			mocha = {
				base = "#0C0C0C",
			},
		},
		custom_highlights = function(colors)
			return {
				-- Trasparent background for floats such as vim.lsp.buf.hover
				NormalFloat = { bg = colors.none },
			}
		end,
		integrations = {
			mason = true,
		},
	},
}
