local M = {}

---@param script string The script to invoke.
---@param args string[]? Additional args to pass to the script, or nil if none.
---@return string
local function _invoke_script(script, args)
	local path = vim.fs.joinpath(vim.fn.stdpath("config"), "lua/utils/python", script)

	local process_args = { "python", path }
	if args then
		process_args = vim.fn.extend(process_args, args)
	end

	local result = vim.system(process_args):wait()
	assert(result.code == 0, "Python subprocess failed! " .. result.stderr)
	return result.stdout
end

---@class EntryPointDef
---@field name string
---@field group string
---@field module string
---@field attr string

---Returns entry-points available in the environment.
---@param group string? If non-nil, only selects entry-points in this group.
---@return EntryPointDef[]
M.list = function(group)
	local args = {}
	if group ~= nil then
		args = { group }
	end

	local result = _invoke_script("list_entry_points.py", args)
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
---@param module string
---@param attr string
---@return string, integer
local function entry_point_location_ts(module, attr)
	assert(
		vim.fn.count(".", attr) == 0,
		"TS implementation can only be used with module attributes, use importlib instead."
	)

	-- It still necessary to use importlib to map the module path to a system
	-- path (where possible). However, this does less module loading and
	-- dependency resolution than loading the entry-point.
	local file_path = _invoke_script("find_entry_point_origin.py", { module })
	file_path = vim.fs.normalize(file_path)

	local file, message = io.open(file_path, "r")
	if not file then
		error("Failed: `" .. message .. "`")
	end
	local file_content = file:read("*a")

	local ts_query = string.format(root_attr_query, attr)
	local parsed_ts_query = vim.treesitter.query.parse("python", ts_query)
	local parser = vim.treesitter.get_string_parser(file_content, "python")

	local root = parser:parse()[1]:root()

	local last_match = -1
	for _, node, _, _ in parsed_ts_query:iter_captures(root, file_content) do
		local row, _, _, _ = node:range()
		last_match = vim.fn.max({ last_match, row + 1 })
	end

	assert(last_match ~= -1, "Could not find a match!")
	return file_path, last_match
end

---@class EntryPoint
---@field name string
---@field group string
---@field filename string
---@field lineno integer

---Returns entry-point location using importlib.
---@param name string
---@param group string
---@return EntryPoint
local entry_point_location_importlib = function(name, group)
	local result = _invoke_script("find_entry_point.py", { name, group })
	return vim.json.decode(result)
end

---@param def EntryPointDef
local function entry_point_location(def)
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
	local ok, result, loc = pcall(entry_point_location_ts, def.module, def.attr)
	if ok then
		return result, loc
	end

	local ep = entry_point_location_importlib(def.name, def.group)
	return ep.filename, ep.lineno
end

---@class	EntryPointPickerOptions
---Maximum display width for entry-point group. Defaults `12`.
---@field group_max_width integer?
---Defaults to `⎸`.
---@field group_separator string?
---If empty, pick from all available groups. Otherwise show only the provided
---`group`. Defaults to `{}`.
---@field group string?

---@type EntryPointPickerOptions
local default_ep_picker_config = {
	group_max_width = 12,
	group_separator = "⎸",
}

---Telescope picker (with preview) for python entry-points.
---@param opts EntryPointPickerOptions? picker options.
M.picker = function(opts)
	---@type EntryPointPickerOptions
	opts = vim.tbl_extend("force", default_ep_picker_config, opts or {})

	local eps = M.list(opts.group)

	local group_width = 0
	for _, ep in ipairs(eps) do
		local len = #ep.group
		if len >= group_width then
			if len >= opts.group_max_width then
				group_width = opts.group_max_width
				break
			end
			group_width = len
		end
	end

	local conf = require("telescope.config").values
	local picker = require("telescope.pickers")
	local finders = require("telescope.finders")
	local entry_display = require("telescope.pickers.entry_display")

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

	vim.print(conf.grep_previewer(opts))

	picker
		.new(opts, {
			prompt_title = "Entry points",
			-- previewer = conf.grep_previewer(opts),
			previewer = require("telescope.previewers").cat,
			sorter = conf.generic_sorter(opts),
			finder = finders.new_table({
				results = eps,
				---@param item EntryPointDef
				entry_maker = function(item)
					local ok, filename, lnum = pcall(entry_point_location, item)
					if ok then
						return {
							value = item,
							ordinal = item.name,
							display = display,
							filename = filename,
							lnum = lnum,
						}
					end
				end,
			}),
		})
		:find()
end

return M
