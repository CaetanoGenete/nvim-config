return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function(_, opts)
		local oil = require("oil")
		oil.setup(opts)

		vim.api.nvim_create_user_command("Explore", function()
			oil.open()
		end, {})
	end,
}
