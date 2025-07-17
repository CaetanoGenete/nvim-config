local M = {}

local entry_points_py_path = vim.fs.joinpath(vim.fn.stdpath("config"), "lua/utils/entry_points.py")

---@class EntryPoint
---@field name string
---@field group string
---@field file_name string?
---@field lineno integer

---Returns entry-points available in the environment.
---@param group string?
---@return EntryPoint[]
M.entry_points = function(group)
	local args = { "python", entry_points_py_path }
	if group ~= nil then
		table.insert(args, group)
	end

	local result = vim.system(args):wait()
	assert(result.code == 0, "Python subprocess failed! " .. result.stderr)
	return vim.json.decode(result.stdout)
end

---@class	EntryPointPickerOptions
---@field group_max_width integer? Maximum display width for entry-point group. Defaults `12`.
---@field group_separator string? Defaults to `⎸`.
---@field group_hl string? Previewer highlight group for group prefix. Defaults to `TelescopeResultsNumber`.
---@field group string? The group/set of groups to display. If empty, pick from all available groups. Otherwise show only the provided `group`. Defaults to `{}`.

---@type EntryPointPickerOptions
local default_ep_picker_config = {
	group_max_width = 12,
	group_separator = "⎸",
	group_hl = "TelescopeResultsNumber",
}

---Telescope picker (with preview) for python entry-points.
---
---@param opts EntryPointPickerOptions? picker options.
M.entry_points_picker = function(opts)
	---@type EntryPointPickerOptions
	opts = vim.tbl_extend("force", default_ep_picker_config, opts or {})

	local eps = M.entry_points(opts.group)

	local group_width = 0
	-- Note: not expecting that many entry-points, so iterating over all elements
	-- is fine.
	for _, ep in ipairs(eps) do
		local len = #ep.group
		if len >= group_width then
			group_width = len
		end
	end

	group_width = vim.fn.min({ group_width, opts.group_max_width })

	local displayer = require("telescope.pickers.entry_display").create({
		separator = opts.group_separator,
		items = {
			{ width = group_width },
			{ remaining = true },
		},
	})

	local display = function(entry)
		return displayer({
			{ entry.value.group, opts.group_hl },
			entry.value.name,
		})
	end

	local conf = require("telescope.config").values
	local picker = require("telescope.pickers")
	local finders = require("telescope.finders")

	picker
		.new({}, {
			prompt_title = "Entry points",
			previewer = conf.grep_previewer({}),
			sorter = conf.generic_sorter({}),
			finder = finders.new_table({
				results = eps,
				---@param item EntryPoint
				entry_maker = function(item)
					return {
						value = item,
						ordinal = item.name,
						display = display,
						filename = item.file_name,
						lnum = item.lineno,
					}
				end,
			}),
		})
		:find()
end

---Fetches the function declaration node surrounding the cursor, or nil if the
---cursor is not within a function.
---@return TSNode|nil
M.function_node_at_cursor = function()
	local utils = require("nvim-treesitter.ts_utils")
	local node = utils.get_node_at_cursor()

	while node ~= nil do
		if node:type() == "function" then
			return node
		end
		node = node:parent()
	end

	return nil
end

return M
