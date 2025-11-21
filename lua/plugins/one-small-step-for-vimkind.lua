vim.api.nvim_create_user_command("StartOSV", function()
	require("osv").launch({ port = 8086 })
end, {})

vim.api.nvim_create_user_command("StopOSV", function()
	local osv = require("osv")
	if osv.is_running() then
		osv.stop()
		vim.notify("OSV server stopped!")
	end
end, {})

---@module "lazy"
---@type LazyPluginSpec
return {
	"jbyuki/one-small-step-for-vimkind",
	lazy = true,
}
