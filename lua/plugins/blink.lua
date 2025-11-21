--- @module "lazy"
--- @type LazyPluginSpec
return {
	"saghen/blink.cmp",
	version = "v1.7.0",
	event = "InsertEnter",
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = { preset = "enter" },
		fuzzy = { implementation = "prefer_rust" },
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				path = {
					opts = {
						get_cwd = function()
							return vim.fn.getcwd()
						end,
					},
				},
			},
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
		},
		signature = {
			enabled = true,
		},
	},
}
