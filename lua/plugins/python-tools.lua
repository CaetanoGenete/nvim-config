---@module "lazy"
---@type LazyPluginSpec
return {
	"CaetanoGenete/python-tools.nvim",
	dev = true,
	config = true,
	keys = {
		{
			"<leader>le",
			function()
				require("python_tools.pickers").find_entry_points({ use_importlib = true })
			end,
			desc = "Find python entry-points",
		},
	},
}
