-- ~/.config/nvim/init.lua

-- bootstrap lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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


-- For file side bar inspector
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- use system clipboard for copy/paste rather than nvim clipboard
vim.opt.clipboard = "unnamedplus"


require("core.options")
require("core.plugins")
require("core.lsp")
require("core.keymaps")
