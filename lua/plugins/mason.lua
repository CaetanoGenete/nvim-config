-- For `BORDER_STYLE`
require("config.editor")

---@module "lazy"
---@type LazyPluginSpec
return {
	"williamboman/mason.nvim",
	version = "v2.0.0",
	cmd = "Mason",
	config = true,
}
