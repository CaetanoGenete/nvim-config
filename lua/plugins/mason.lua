require("config.display")

---@module "lazy"
---@type LazyPluginSpec
return {
	"williamboman/mason.nvim",
	cmd = "Mason",
	--- @module "mason"
	--- @type MasonSettings
	opts = {
		ui = {
			border = BORDER_STYLE,
		},
	},
}
