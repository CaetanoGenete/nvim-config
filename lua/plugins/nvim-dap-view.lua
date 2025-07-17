---@module "lazy"
---@type LazyPluginSpec
return {
	"igorlfs/nvim-dap-view",
	commit = "fc0315087a871f9e74ef88559760b81dae81bc6d",
	lazy = true,
	---@module "dap-view"
	---@type dapview.Config
	opts = {
		winbar = {
			sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
		},
		windows = {
			position = "right",
		},
	},
	keys = {
		{
			"<leader>dv",
			function()
				require("dap-view").open()
			end,
			desc = "Opens nvim-dap-viw windows",
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dap_view = require("dap-view")
		dap_view.setup(opts)

		local open_listeners = {
			dap.listeners.before.attach,
			dap.listeners.before.launch,
		}
		for _, listener in ipairs(open_listeners) do
			listener["dav-view-config"] = function()
				dap_view.open()
			end
		end
	end,
}
