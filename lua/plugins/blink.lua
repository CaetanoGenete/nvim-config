require("config.display")

--- @module "lazy"
--- @type LazyPluginSpec
return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = { preset = "enter" },
		fuzzy = { implementation = "lua" },
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
		completion = {
			menu = { border = BORDER_STYLE },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { border = BORDER_STYLE },
			},
		},
		signature = {
			enabled = true,
			window = { border = BORDER_STYLE },
		},
	},
}
