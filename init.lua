require("config.mappings")
require("config.editor")
require("config.lsp")
-- ? Note: must come after setting the leader.
require("config.lazy")

vim.cmd.colorscheme("catppuccin")

-- Load user-config last
pcall(require, "user.init")
