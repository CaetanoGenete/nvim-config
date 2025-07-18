--- Copied from: https://github.com/folke/lazy.nvim. Bootstraps Lazy.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- For `BORDER_STYLE`
require("config.editor")

require("lazy").setup({
	spec = { { import = "plugins" } },
	checker = { enabled = true },
	ui = {
		border = BORDER_STYLE,
	},
	rocks = {
		enabled = false,
	},
})
