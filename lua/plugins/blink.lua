-- For `BORDER_STYLE`
require("config.editor")

--- @module "lazy"
--- @type LazyPluginSpec
return {
	"saghen/blink.cmp",
	version = "v1.4.1",
	event = "InsertEnter",
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = { preset = "enter" },
		fuzzy = { implementation = "prefer_rust" },
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
			-- menu = { border = BORDER_STYLE },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				-- window = { border = BORDER_STYLE },
			},
		},
		signature = {
			enabled = true,
			-- window = { border = BORDER_STYLE },
		},
	},
}
