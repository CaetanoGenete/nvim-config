local async = require("utils.async")

local conf = require("telescope.config").values
local picker = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local entry_display = require("telescope.pickers.entry_display")
local putils = require("telescope.previewers.utils")

-- For highlighting purposes
local ns_previewer = vim.api.nvim_create_namespace("telescope.previewers")

local M = {}

---@async
---@param script string The script to invoke.
---@param args string[]? Additional args to pass to the script, or `nil` if none.
---@return string
local function ainvoke_script(script, args)
	local path = vim.fs.joinpath(vim.fn.stdpath("config"), "lua/utils/python", script)

	local process_args = { "python", path }
	for _, arg in ipairs(args or {}) do
		table.insert(process_args, arg)
	end

	local result = async.system(process_args, { text = true, timeout = 5000 })
	assert(result.code == 0, "Python subprocess failed! " .. result.stderr)
	return result.stdout
end

---@class EntryPointDef
---@field name string
---@field group string
---@field module string
---@field attr string

---Returns entry-points available in the environment.
---@async
---@param group string? If non-nil, only selects entry-points in this group.
---@return EntryPointDef[]
M.list = function(group)
	local args = {}
	if group ~= nil then
		args = { group }
	end

	local result = ainvoke_script("list_entry_points.py", args)
	return vim.json.decode(result)
end

local root_attr_query = [[
	(module
		[
			(function_definition
				name: (_) @entry_point_name)
		  (expression_statement
				(assignment 
					left: (_) @entry_point_name))
		]
		(#eq? @entry_point_name "%s")
	)
]]

---Uses treesitter to find entry-point location in source code.
---
---For simple *entry-points*, it should be more accurate.
---@async
---@param module string
---@param attr string?
---@return string, integer
local function aentry_point_location_ts(module, attr)
	assert(
		attr == nil or vim.fn.count(".", attr) == 0,
		"TS implementation can only be used with module attributes, use importlib instead."
	)

	-- It still necessary to use importlib to map the module path to a system
	-- path (where possible). However, this does less module loading and
	-- dependency resolution than loading the entry-point.
	local file_path = ainvoke_script("find_entry_point_origin.py", { module })

	file_path = vim.fs.normalize(file_path)
	local lnum = 0

	-- If `attr` is None, then entry-point invokes module.
	if attr then
		local errmsg, file_content = async.read_file(file_path)
		if not file_content then
			error(errmsg)
		end

		local ts_query = string.format(root_attr_query, attr)
		local parsed_ts_query = vim.treesitter.query.parse("python", ts_query)
		local parser = vim.treesitter.get_string_parser(file_content, "python")

		local root = parser:parse()[1]:root()

		local last_match = -1
		for _, node, _, _ in parsed_ts_query:iter_captures(root, file_content) do
			local row, _, _, _ = node:range()
			last_match = math.max(last_match, row + 1)
		end

		assert(last_match ~= -1, "Could not find a match!")
		lnum = last_match
	end

	return file_path, lnum
end

---@class EntryPoint
---@field name string
---@field group string
---@field filename string
---@field lineno integer

---Returns entry-point location using importlib.
---@async
---@param name string
---@param group string
---@return EntryPoint
local aentry_point_location_importlib = function(name, group)
	local result = ainvoke_script("find_entry_point.py", { name, group })
	return vim.json.decode(result)
end

---@async
---@param def EntryPointDef
local function aentry_point_location(def)
	-- Try to use tree-sitter implementation first. And fallback to importlib if
	-- this fails.
	--
	-- There are a few reasons for this:
	-- 1. importlib can fail despite the entry point being valid. If, for
	-- example, a dependency is not available, importlib will fail without
	-- returning the location of the entry-point.
	-- 2. importlib will not return the exact location of an entry-point if it is
	-- not a function. Take for example `ep = main`, where `main` is a function.
	-- With the current importlib implementation, if `ep` is defined as the
	-- entry-point, the location will resolve to the definition of `main`.
	--
	-- None of these issues appear when fetching the entry-point using
	-- tree-sitter, as no dependency resolution occurs. However, it cannot follow
	-- chains of attributes, such as `a.b.c`.
	local ok, result, loc = pcall(aentry_point_location_ts, def.module, def.attr)
	if ok then
		return result, loc
	end

	local ep = aentry_point_location_importlib(def.name, def.group)
	return ep.filename, ep.lineno
end

---@class	EntryPointPickerOptions
---Maximum display width for entry-point group. Defaults `12`.
---@field group_max_width integer?
---Defaults to `⎸`.
---@field group_separator string?
---If empty, pick from all available groups. Otherwise show only the provided
---`group`. Defaults to `nil`.
---@field group string?
---Additional telescope options.
---@field [string] any

---@type EntryPointPickerOptions
local default_ep_picker_config = {
	group_max_width = 12,
	group_separator = "⎸",
	preview = {},
}

---Centers the viewport at `lnum` for the given `bufnr`.
---
---Also moves the cursor to `winid`.
---@param winid integer
---@param bufnr integer
---@param lnum integer?
local jump_to_line = function(winid, bufnr, lnum)
	pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns_previewer, 0, -1)
	if lnum == nil or lnum == 0 then
		return
	end

	---@diagnostic disable-next-line: deprecated
	pcall(vim.api.nvim_buf_add_highlight, bufnr, ns_previewer, "TelescopePreviewLine", lnum - 1, 0, -1)
	pcall(vim.api.nvim_win_set_cursor, winid, { lnum, 0 })

	vim.api.nvim_buf_call(bufnr, function()
		vim.cmd("norm! zz")
	end)
end

---@class PreviewerState
---@field bufnr integer
---@field winid integer
---@field bufname string?

---@class EntryPointEntry
---@field value EntryPointDef
---@field ordinal string
---@field displayer fun(...): ...
---@field filename string?
---@field lnum integer?

---@param state PreviewerState
---@param entry EntryPointEntry
---@param opts EntryPointPickerOptions
local function render_entry(state, entry, opts)
	if entry.filename ~= nil then
		conf.buffer_previewer_maker(entry.filename, state.bufnr, {
			bufname = state.bufname,
			winid = state.winid,
			preview = opts.preview,
			---@param bufnr integer
			callback = function(bufnr)
				jump_to_line(state.winid, bufnr, entry.lnum)
			end,
			file_encoding = opts.file_encoding,
		})
	else
		vim.schedule_wrap(putils.set_preview_message)(
			state.bufnr,
			state.winid,
			"Cannot find entrypoint!",
			opts.preview.msg_bg_fillchar
		)
	end
end

---@async
---@param eps EntryPointDef[]
---@param opts EntryPointPickerOptions picker options.
local function apick(eps, opts)
	local group_width = 0
	for _, ep in ipairs(eps) do
		local len = #ep.group
		if len >= opts.group_max_width then
			group_width = opts.group_max_width
			break
		end
		group_width = math.max(group_width, len)
	end

	local displayer = entry_display.create({
		separator = opts.group_separator,
		items = {
			{ width = group_width },
			{ remaining = true },
		},
	})

	local display = function(entry)
		return displayer({
			{ entry.value.group, "TelescopeResultsNumber" },
			entry.value.name,
		})
	end

	---Cache fetched entry-point locations during this picker session.
	---@type table<string, "done"|"pending"|nil>
	local entry_states = {}
	local selected = nil

	local previewer = previewers.new_buffer_previewer({
		title = "Entry-point Preview",
		---@param entry EntryPointEntry
		define_preview = function(self, entry, _)
			local cache_key = entry.value.group .. ":" .. entry.value.name
			selected = cache_key

			local entry_state = entry_states[cache_key]
			if entry_state == "pending" then
				return
			end

			if entry_state == "done" then
				render_entry(self.state, entry, opts)
			else
				async.run(function(curr)
					entry_states[curr] = "pending"
					local ok, filename, lnum = pcall(aentry_point_location, entry.value)
					entry_states[curr] = "done"

					if ok then
						entry.filename = filename
						entry.lnum = lnum
					end

					-- Avoid rendering if the user has selected something else in the meantime
					if selected == curr then
						render_entry(self.state, entry, opts)
					end
				end, cache_key)
			end
		end,
	})

	local finder = finders.new_table({
		results = eps,
		---@param item EntryPointDef
		---@return EntryPointEntry
		entry_maker = function(item)
			return {
				value = item,
				ordinal = item.name,
				display = display,
			}
		end,
	})

	vim.schedule(function()
		picker
			.new(opts, {
				prompt_title = "Entry points",
				previewer = previewer,
				sorter = conf.generic_sorter(opts),
				finder = finder,
			})
			:find()
	end)
end

---Telescope picker (with preview) for python entry-points.
---@param opts EntryPointPickerOptions? picker options.
M.find_entrypoints = function(opts)
	---@type EntryPointPickerOptions
	opts = vim.tbl_extend("force", default_ep_picker_config, opts or {})

	async.run_callback(M.list, function(ok, eps)
		if ok then
			apick(eps, opts)
		end
	end, opts.group)
end

return M
