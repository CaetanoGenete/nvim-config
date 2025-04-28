local logger = require("utils.log")

if vim.lsp._enabled_configs["ruff"] ~= nil then
	logger.fmt_info("`ruff` detected, disabling pyright analysis.")

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
end
