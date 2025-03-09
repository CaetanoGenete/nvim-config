---@module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*",
		lazy = true,
		opts = {
			update_events = { "TextChanged", "TextChangedI" },
			enable_autosnippets = true,
			store_selection_keys = "<Tab>",
		},
		config = function(_, opts)
			require("luasnip").setup(opts)
			require("luasnip.loaders.from_lua").lazy_load({ paths = { "./lua/snippets/" } })
		end,
		build = function()
			if vim.fn.executable("make") == 1 then
				vim.fn.execute("make install_jsregexp")
			end
		end,
	},
}
