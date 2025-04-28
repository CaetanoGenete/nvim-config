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
		transparent_background = true,
		custom_highlights = function(colors)
			return {
				-- Trasparent background for floats such as vim.lsp.buf.hover
				NormalFloat = { bg = colors.none },
				Pmenu = { bg = colors.none },
			}
		end,
	},
}
