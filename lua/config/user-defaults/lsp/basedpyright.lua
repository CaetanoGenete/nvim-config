local log = require("utils.log")

M = {}

local root_files = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"Pipfile",
	"pyrightconfig.json",
	".git",
}

local using_ruff = require("config.user-defaults.config").ls_enabled("ruff")
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
	M.root_dir = function(fname)
		return require("lspconfig.util").root_pattern(unpack(root_files))(fname)
	end
end

return M
