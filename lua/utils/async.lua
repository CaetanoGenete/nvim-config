local M = {}

local wrap = function(callback_fn, exp_args)
	---@async
	local function async_fn(...)
		local nargs = select("#", ...)

		if exp_args ~= nargs then
			error("This function only accepts `" .. exp_args .. "` but `" .. nargs .. "` passed!")
		end

		local coro = coroutine.running()
		assert(coro ~= nil, "Async function called outside of coroutine!")

		local callback_completed = false
		local callback_ret = nil

		local forward_args = { ... }
		table.insert(forward_args, function(...)
			callback_completed = true
			callback_ret = { ... }

			if coroutine.status(coro) == "suspended" then
				coroutine.resume(coro)
			end
		end)

		callback_fn(unpack(forward_args))

		if not callback_completed then
			-- If we are here, then `f` must not have called the callback yet, so it
			-- will do so asynchronously.
			-- Yield control and wait for the callback to resume it.
			coroutine.yield()
		end

		if callback_ret == nil then
			return nil
		end
		return unpack(callback_ret)
	end

	return async_fn
end

---@async
---@type fun(cmd:string[], opts:vim.SystemOpts): vim.SystemCompleted
M.system = wrap(vim.system, 2)

---@async
---@type fun(path:string, flags:string|integer, mode:integer):string?,integer?
M.fs_open = wrap(vim.uv.fs_open, 3)

---@async
---@type fun(fd:integer):string?,integer?
M.fs_close = wrap(vim.uv.fs_close, 3)

---@async
---@type fun(fd:integer, size:integer, offset:integer?):string?,string?
M.fs_read = wrap(vim.uv.fs_read, 3)

---@class UVStat
---@field dev integer
---@field mode integer
---@field nlink integer
---@field uid integer
---@field gid integer
---@field rdev integer
---@field ino integer
---@field size integer
---@field blksize integer
---@field blocks integer
---@field flags integer
---@field gen integer
---@field type string

---@async
---@type fun(fd: integer):string?,UVStat?
M.fs_stat = wrap(vim.uv.fs_fstat, 1)

--- Executes an async function. This is effectively a fire and forget.
---@param async_function fun(...):...
M.run = function(async_function, ...)
	coroutine.resume(coroutine.create(async_function), ...)
end

--- Executes an async function. If the returned coroutine is discarded, this is
--- effectively a fire and forget.
---@generic T
---@param async_function fun(...): T
---@param cb fun(success: boolean, result: T?)
M.run_callback = function(async_function, cb, ...)
	M.run(function(...)
		local ok, result = pcall(async_function, ...)
		cb(ok, result)
	end, ...)
end

---Returns the contents of the file at `path`.
---@async
---@param path string
---@return string?, string?
M.read_file = function(path)
	local err, fd = M.fs_open(path, "r", 438)
	if err or fd == nil then
		return err, nil
	end

	local stat_err, stat = M.fs_stat(fd)
	if stat_err or stat == nil then
		M.fs_close(fd)
		return stat_err, nil
	end

	local read_err, data = M.fs_read(fd, stat.size, 0)
	if read_err or data == nil then
		M.fs_close(fd)
		return read_err, nil
	end

	return nil, data
end

return M
