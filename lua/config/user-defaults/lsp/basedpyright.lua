local enabled_languages = require("config.user-defaults.config").language_servers
local using_ruff = enabled_languages["ruff"] or false

local log = require("utils.log")

M = {
	settings = {
		pyright = {
			disableOrganizeImports = using_ruff,
		},
	},
}

if using_ruff then
	log.debug("Disabling basedpyright lint warnings in favour of ruff")
	-- Ignore all files for analysis to exclusively use Ruff for linting
	M.settings.python = {
		analysis = {
			ignore = { "*" },
		},
	}
end

return M
