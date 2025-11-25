---@param dap_coro thread
local function dap_abort(dap_coro)
	coroutine.resume(dap_coro, require("dap").ABORT)
end

---@async
---@param dap_coro thread
local function adebug_entrypoint(dap_coro)
	local eps, err =
		require("python_tools.meta.entry_points").aentry_points({ group = "console_scripts" })

	if eps == nil then
		vim.notify(("Failed to find entry_points: %s"):format(err), vim.log.levels.ERROR)
		dap_abort(dap_coro)
		return
	end

	---@param ep EntryPointDef
	local function on_selected(ep)
		if ep == nil then
			dap_abort(dap_coro)
			return
		end
		coroutine.resume(dap_coro, { ep.name, ep.group })
	end

	if #eps == 1 then
		on_selected(eps[1])
		return
	end

	vim.ui.select(eps, {
		prompt = "Choose an entry point:",
		---@param ep EntryPointDef
		format_item = function(ep)
			return ep.name
		end,
	}, on_selected)
end

return {
	{
		type = "python",
		request = "launch",
		name = "Launch python file",
		program = "${file}",
	},
	{
		type = "python",
		request = "launch",
		name = "Launch console_script",
		program = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "dap", "_scripts", "launcher.py"),
		args = function()
			return coroutine.create(adebug_entrypoint)
		end,
	},
}
