return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*",
	event = "VeryLazy",
	build = function()
		if vim.fn.executable("make") == true then
			vim.fn.execute("make install_jsregexp")
		end
	end,
}
