-- ~/.config/nvim/init.lua

-- For file side bar inspector
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- use system clipboard for copy/paste rather than nvim clipboard
vim.opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.plugins")
require("core.lsp")
require("core.keymaps")
