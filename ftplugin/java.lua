local user_settings = require("config.user-defaults.config")
if not user_settings.language_servers["jdtls"] then
	return
end

local config = require("config.user-defaults.lsp.jdtls")

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
