---Gets the `name` field of `*definition` TS python node.
---@param node TSNode
---@return string
local function declaration_name(node)
	assert(
		node:type() == "function_definition" or node:type() == "class_definition",
		"ERROR: `node` must be a *definition type, was instead" .. node:type()
	)

	local name_id = node:field("name")[1]
	local row_s, col_s, row_e, col_e = name_id:range()
	return vim.api.nvim_buf_get_text(0, row_s, col_s, row_e, col_e, {})[1]
end

---Generates the `::` delimeted path to the function under the cursor.
---@return string|nil
local function pytest_path_at_cursor()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()

	---@type string[]
	local path = {}

	while node ~= nil do
		local type = node:type()
		if type == "function_definition" then
			path = { declaration_name(node) }
		elseif type == "class_definition" then
			table.insert(path, declaration_name(node))
		end

		node = node:parent()
	end

	if vim.fn.empty(path) == 1 then
		return nil
	end

	return table.concat(vim.fn.reverse(path), "::")
end

local function debug_test_under_cursor()
	local buffer_path = vim.api.nvim_buf_get_name(0)
	local pytest_path = pytest_path_at_cursor()

	if pytest_path == nil then
		vim.notify("Cursor is not within a valid function!", vim.log.levels.ERROR)
		return
	end

	local config = {
		name = "pytest - " .. pytest_path,
		type = "python",
		request = "launch",
		module = "pytest",
		args = { "-s", buffer_path .. "::" .. pytest_path },
	}
	require("dap").run(config)
end

vim.api.nvim_buf_create_user_command(0, "DebugTest", function()
	debug_test_under_cursor()
end, { desc = "Execute function under cursor using `pytest`, using a configured debugger." })

vim.keymap.set("n", "<leader>dt", function()
	debug_test_under_cursor()
end, { buffer = 0 })
