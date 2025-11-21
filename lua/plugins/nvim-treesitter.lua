---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	version = "v0.10.0",
	branch = "main",
	event = "BufRead",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	--- @module "nvim-treesitter"
	--- @type TSConfig
	opts = {
		ensure_installed = { "lua" },
		ignore_install = {},
		sync_install = false,
		auto_install = true,
		modules = {},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
	},
}
