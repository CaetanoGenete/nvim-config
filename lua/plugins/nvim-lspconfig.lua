---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	version = "v2.11.0",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "saghen/blink.cmp" },
}
