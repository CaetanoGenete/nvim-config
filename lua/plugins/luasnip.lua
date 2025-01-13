---@module "lazy"
---@type (LazyPluginSpec)[]
return {
	{
		"saadparwaiz1/cmp_luasnip",
		event = "VeryLazy",
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*",
		event = "VeryLazy",
		config = function()
			local luasnip = require("luasnip")

			require("luasnip.loaders.from_lua").lazy_load({ paths = { "./lua/snippets/" } })

			luasnip.setup({
				update_events = { "TextChanged", "TextChangedI" },
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
			})

			local default_opts = {
				silent = true,
				noremap = true,
			}

			vim.keymap.set({ "i" }, "<C-K>", function()
				luasnip.expand()
			end, default_opts)

			vim.keymap.set({ "i", "s" }, "<C-L>", function()
				luasnip.jump(1)
			end, default_opts)

			vim.keymap.set({ "i", "s" }, "<C-J>", function()
				luasnip.jump(-1)
			end, default_opts)
		end,
		build = function()
			if vim.fn.executable("make") then
				vim.fn.execute("make install_jsregexp")
			end
		end,
	},
}
