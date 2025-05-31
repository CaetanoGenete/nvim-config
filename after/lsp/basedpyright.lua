if require("utils.lsp").lsp_enabled("ruff") then
	require("utils.log").fmt_info("`ruff` detected, disabling pyright analysis.")

	return {
		settings = {
			python = {
				analysis = {
					-- Use `basedpyright` only for type-analysis, assume something else
					-- like `ruff` or `pylint` is providing linting.
					ignore = { "*" },
				},
			},
			pyright = {
				-- Use organizeImports from `ruff`
				disableOrganizeImports = true,
			},
		},
	}
end
