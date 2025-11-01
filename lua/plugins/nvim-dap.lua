---Loads DAP configuration for the given buffer (with id `bufnr`).
---
---Function will look for files in the following directories:
---	- lua/dap
---	- lua/user/path
---matching `filetype.lua`. Where `filetype` is the filetype of the specified buffer.
---
---**Duplicates will be concatenated.**
---@param bufnr integer
local function load_config(bufnr)
	local logger = require("utils.log")

	local ft = vim.bo[bufnr].filetype
	local config_paths = { "dap.", "user.dap." }

	--- @type dap.Configuration[]
	local configurations = {}

	for _, config_path in ipairs(config_paths) do
		local module = config_path .. ft
		logger.fmt_info("Trying to load config: %s", module)

		if require("utils.module").module_exists(module) then
			---@type dap.Configuration | dap.Configuration[]
			local config = require(module)
			if not vim.islist(config) then
				config = { config }
			end

			vim.list_extend(configurations, config)
			logger.fmt_info("Successfully loaded: %s", module)
		else
			logger.fmt_info("Could not find module: %s", module)
		end
	end

	return configurations
end

---@module "lazy"
---@type LazyPluginSpec
return {
	"mfussenegger/nvim-dap",
	commit = "5dd4d50f2e6a2eaf9e57fad023d294ef371bda35",
	dependencies = {
		-- Note: These are not strictly dependencies, but should be loaded with nvim-dap.
		"igorlfs/nvim-dap-view",
		"theHamsta/nvim-dap-virtual-text",
	},
	cmd = "DapContinue",
	---@type LazyKeysSpec[]
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle breakpoint at cursor.",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Run using previously executing config.",
		},
	},
	config = function()
		local dap = require("dap")

		-- Keymaps
		vim.keymap.set("n", "<F1>", function()
			dap.continue({ new = false })
		end)
		vim.keymap.set("n", "<F2>", function()
			dap.step_into()
		end)
		vim.keymap.set("n", "<F3>", function()
			dap.step_over()
		end)
		vim.keymap.set("n", "<F4>", function()
			dap.step_out()
		end)
		vim.keymap.set("n", "<F5>", function()
			dap.run_to_cursor()
		end)

		-- Custom adapters
		require("config.dap.python_adapter")

		-- Lazy config loading
		dap.providers.configs["lazy-dap-configs"] = load_config

		dap.listeners.on_config["my-config"] = function(config)
			vim.notify("Launching debug session: " .. config.name)
			return config
		end

		dap.listeners.after.event_exited["my-config"] = function(session, body)
			local exit_code = body.exitCode
			local status = "unknown exit code."
			local level = vim.log.levels.WARN

			if type(exit_code) == "number" then
				status = "status code - " .. exit_code
				if exit_code == 0 then
					level = vim.log.levels.INFO
				end
			end

			vim.notify("Process `" .. session.config.name .. "` exited with " .. status, level)
		end
	end,
}
