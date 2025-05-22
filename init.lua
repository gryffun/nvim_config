-- ~/.config/nvim/init.lua

-- For file side bar inspector
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- use system clipboard for copy/paste rather than nvim clipboard
vim.opt.clipboard = "unnamedplus"

-- currently working on setting up lsp stuff

require("core.options")
require("core.plugins")
require("core.lsp")
require("core.keymaps")
