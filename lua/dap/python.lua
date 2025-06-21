---@return boolean
local function windows()
	return vim.fn.has("win32") == 1
end

---@param venv_path string
---@param w boolean?
---@return string|nil
local function get_python_exe(venv_path, w)
	if not venv_path then
		return nil
	end

	local exec_name = ""
	if w then
		exec_name = "pythonw"
	else
		exec_name = "python"
	end

	if windows() then
		return vim.fs.joinpath(venv_path, "Scripts", exec_name .. ".exe")
	end
	return vim.fs.joinpath(venv_path, "bin", exec_name)
end

---@return string|nil
local function get_python_path()
	local venv_path = os.getenv("VIRTUAL_ENV")
	if not venv_path then
		return nil
	end

	return get_python_exe(venv_path)
end

local function get_debugpy_python_exe()
	local mason_venv = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv")
	if vim.fn.isdirectory(mason_venv) then
		return get_python_exe(mason_venv, true)
	else
		vim.notify("Could not find mason debugpy installation" .. vim.notify(mason_venv))
	end
	return "python"
end

local dap = require("dap")
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
		})
	else
		cb({
			type = "executable",
			command = get_debugpy_python_exe(),
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			},
		})
	end
end

-- nvim-dap logs warnings for unhandled custom events. Mute it.
dap.listeners.before["event_debugpySockets"]["dap-python"] = function() end

return {
	type = "python",
	request = "launch",
	name = "Launch file",
	program = "${file}",
	pythonPath = function()
		local path = get_python_path() or "python"
		vim.notify("Using python executable: " .. path)
		return path
	end,
	console = "integratedTerminal",
}
