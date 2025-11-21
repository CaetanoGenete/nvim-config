local dap = require("dap")

---@return boolean
local function windows()
	return vim.fn.has("win32") == 1
end

---@param venv_path string The directory to the virtual environment
---@param w? boolean If `true`, on windows, find `pythonw.exe` instead of `python.exe`. Defaults to false
---@return string|nil
local function get_python_exe(venv_path, w)
	if not venv_path then
		return nil
	end

	if windows() then
		local executable = ""
		if w then
			executable = "pythonw.exe"
		else
			executable = "python.exe"
		end
		return vim.fs.joinpath(venv_path, "Scripts", executable)
	end
	return vim.fs.joinpath(venv_path, "bin", "python")
end

---Looks for python executable in the activated virtual environment.
---
---Returns `nil` instead if no virtual environment is detected.
---@return string|nil
local function get_python_path()
	local venv_path = os.getenv("VIRTUAL_ENV")
	if not venv_path then
		return nil
	end

	return get_python_exe(venv_path)
end

---Looks for _debugpy_ in mason registry. If it cannot find it, returns _python_ instead.
---@return string
local function debugpy_python_exe()
	local mason_venv = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv")
	if vim.fn.isdirectory(mason_venv) then
		local result = get_python_exe(mason_venv, true)
		if result ~= nil then
			return result
		end
	end

	vim.notify("Could not find mason debugpy installation" .. vim.notify(mason_venv))
	return "python"
end

local enrich_config = function(config, on_config)
	if not config.pythonPath and not config.python then
		config.pythonPath = get_python_path() or "python"
	end

	if not config.console then
		config.console = "integratedTerminal"
	end

	if not config.cwd then
		config.cwd = vim.fn.getcwd()
	end

	on_config(config)
end

-- nvim-dap logs warnings for unhandled custom events. Mute it.
dap.listeners.before["event_debugpySockets"]["dap-python"] = function() end

dap.adapters.python = function(cb, config)
	if config.request == "attach" then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or "127.0.0.1"

		cb({
			type = "server",
			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			host = host,
			options = {
				source_filetype = "python",
			},
			enrich_config = enrich_config,
		})
	else
		cb({
			type = "executable",
			command = debugpy_python_exe(),
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			},
			enrich_config = enrich_config,
		})
	end
end
