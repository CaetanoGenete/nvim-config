if not require("config.user-defaults.config").ls_enabled("jdtls") then
	return
end

local config = require("config.user-defaults.lsp.jdtls")
require("jdtls").start_or_attach(config)
