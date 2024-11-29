return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown({}) },
			},
		},
		config = function()
			local builtin = require("telescope.builtin")

			-- key mappings
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find git files" })

			-- telescope ui
			require("telescope").load_extension("ui-select")
		end,
	},
}
