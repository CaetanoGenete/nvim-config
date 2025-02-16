---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	name = "treesitter",
	build = ":TSUpdate",
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
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
