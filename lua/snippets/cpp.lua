--- Gets the path of the current buffer, relative to the workspace directory (as defined by the active LSP),
--- transforming it such that it becomes a valid macro expression.
---
--- The following alterations are made (in order):
--- - Convert to upper-case
--- - Replace all non alpha-numeric characters with '_'
---
--- @return string
local function cpp_include_path(_, _)
	---@type string
	local workspace = vim.lsp.buf.list_workspace_folders()[1]
	-- Note: Using buffer path instead of TM_FILEPATH to support previews with nvim-cmp
	local file_path = vim.api.nvim_buf_get_name(0)

	-- Get path of current buffer, relative to the workspace
	local rel_path = string.sub(file_path, #workspace + 1 + #"/include/", #file_path)
	rel_path = string.upper(rel_path)
	rel_path = string.gsub(rel_path, "[^A-Z0-9]", "_")

	return rel_path
end

return {
	s(
		{
			trig = "guard",
			snippetType = "snippet",
			desc = "Adds GoogleStyle header-guard and namespace declaration to the current .hpp file.",
		},
		fmt(
			[[
				#ifndef {path}
				#define {path}
				
				namespace {namespace} {{
					{code}
				}} // namespace {namespace}

				#endif // !{path}
			]],
			{
				path = f(cpp_include_path, {}),
				namespace = i(1, "namespace"),
				code = i(2, "code"),
			},
			{
				repeat_duplicates = true,
			}
		)
	),
}
