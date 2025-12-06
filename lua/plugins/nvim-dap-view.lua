---@module "lazy"
---@type LazyPluginSpec
return {
	"igorlfs/nvim-dap-view",
	commit = "25ffcf3a6d8d44b6275dac9d5ff9b1f9485907d9",
	lazy = true,
	enabled = true,
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
