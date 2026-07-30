---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	commit = "4916d6592ede8c07973490d9322f187e07dfefac",
	lazy = false,
	build = ":TSUpdate",
}
