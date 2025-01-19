local enabled_languages = require("config.user-defaults.config").language_servers

---@module "lazy"
---@type LazyPluginSpec
return {
	"mfussenegger/nvim-jdtls",
	ft = "java", -- only load if a java file has been opened
	commit = "baae618", -- Use version of jdtls that supports java 17
	enabled = enabled_languages["jdtls"] or false,
}
