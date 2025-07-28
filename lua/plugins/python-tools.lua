---@module "lazy"
---@type LazyPluginSpec
return {
	"CaetanoGenete/python-tools.nvim",
	lazy = true,
	dev = true,
	keys = {
		{
			"<leader>le",
			function()
				require("python_tools.pickers").find_entry_points()
			end,
			desc = "Find python entry-points",
		},
	},
}
