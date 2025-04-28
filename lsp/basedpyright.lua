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
			disableOrganizeImports = true,
		},
	},
}
