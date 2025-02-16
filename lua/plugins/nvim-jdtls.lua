---@module "lazy"
---@type LazyPluginSpec
return {
	"mfussenegger/nvim-jdtls",
	ft = "java",     -- only load if a java file has been opened
	commit = "baae618", -- Use version of jdtls that supports java 17
	enabled = require("config.user-defaults.config").ls_enabled("jdtls"),
}
