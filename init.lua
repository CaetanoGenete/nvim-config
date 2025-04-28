require("config.mappings")
require("config.editor")
require("config.misc")
require("config.lsp")
-- ? Note: must come after setting the leader.
require("config.lazy")

vim.cmd.colorscheme("catppuccin")

pcall(require, "user.init")
