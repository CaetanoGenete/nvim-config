---@param path string
local function activate_python_env(path)
	if vim.fn.has("win32") then
		vim.fn.execute(path .. "\\Scripts\\activate.bat")
	else
		-- Assume Posix OS
		vim.fn.execute("source " .. path .. "/bin/activate")
	end
end

local function select_python_env()
	local directories = {}

	local candidates = { "/venv", "/.venv" }
	local pwd = vim.fs.normalize(vim.fn.getcwd() .. "/")

	for _, candidate in ipairs(candidates) do
		if vim.fn.isdirectory(pwd .. candidate) == 1 then
			table.insert(directories, candidate)
		end
	end

	if #directories > 0 then
		vim.ui.select(directories, {}, function(item, idx) end)
	else
		vim.notify("No virtual environments found!", vim.log.levels.ERROR)
	end
end

vim.api.nvim_buf_create_user_command(0, "PySelectEnv", select_python_env, {})
