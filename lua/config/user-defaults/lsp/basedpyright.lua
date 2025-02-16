local log = require("utils.log")
local using_ruff = require("config.user-defaults.config").ls_enabled("ruff")

M = {}

if using_ruff then
	log.debug("Ruff detected.")
	log.debug("Disabling basedpyright lint warnings in favour of ruff.")
	log.debug("Disabling basedpyright organise imports in favour of ruff.")
	-- Ignore all files for analysis to exclusively use Ruff for linting
	M.settings = {
		python = {
			analysis = {
				ignore = { "*" },
			},
		},
		pyright = {
			disableOrganizeImports = true,
		},
	}
end

return M
