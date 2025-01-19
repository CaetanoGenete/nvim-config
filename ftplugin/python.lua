--- Searchs for python virtual environments in known locations.
--- @return string[]
local function discover_python_envs()
	--- @type string[]
	local results = {}

	local search
	if vim.fn.has("win32") == 1 then
		search = "\\Scripts\\Activate.ps1"
	else
		search = "/bin/activate"
	end

	local cwd = vim.fn.getcwd()

	local candidates = { "/venv/", "/.venv/" }
	for _, candidate in ipairs(candidates) do
		local full_path = vim.fs.normalize(vim.fs.joinpath(cwd, candidate))
		if vim.fn.filereadable(vim.fs.joinpath(full_path, search)) == 1 then
			table.insert(results, full_path)
		end
	end

	return results
end

--- Attempts to activate virtual evironment pointed to by `path`.
--- @param path string The path to the root of the virtual environment
local function activate_python_env(path) end

vim.api.nvim_buf_create_user_command(0, "PySelectEnv", function()
	local options = discover_python_envs()

	if #options > 0 then
		vim.ui.select(options, {}, function(choice)
			if choice ~= nil then
				activate_python_env(choice)
			end
		end)
	else
		vim.notify("No virtual environments found!", vim.log.levels.ERROR)
	end
end, {})
