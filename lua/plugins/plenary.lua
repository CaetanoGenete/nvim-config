---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-lua/plenary.nvim",
	commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509",
	lazy = true,
	cmd = {
		"PlenaryBustedDirectory",
		"PlenaryBustedFile",
	},
}
