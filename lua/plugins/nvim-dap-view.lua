---@module "lazy"
---@type LazyPluginSpec
return {
	"igorlfs/nvim-dap-view",
	commit = "c7385808c7d6a4438f6eef50d539d7103146ba2b",
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
				require("dap-view").toggle(true)
			end,
			desc = "Opens nvim-dap-viw windows",
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dap_view = require("dap-view")
		dap_view.setup(opts)

		dap.listeners.before.event_stopped["dav-view-config"] = function()
			dap_view.open()
		end
	end,
}
