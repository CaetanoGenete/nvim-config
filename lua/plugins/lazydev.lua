---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/lazydev.nvim",
	version = "v1.10.0",
	ft = "lua", -- only load on lua files
	config = true,
}
