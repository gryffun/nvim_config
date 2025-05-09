-- core/keymaps.lua
local keymap = vim.keymap.set



-- Space as leader key
vim.g.mapleader = " "

vim.api.nvim_set_keymap('i', '<C-H>', '<C-w>', { noremap = true })

keymap("i", "C-BS", "C-w", {noremap=true})
keymap("n", "<leader>w", ":w<CR>")     -- save file
keymap("n", "<leader>qq", ":q<CR>")     -- quit 


-- coq remaps
-- Disable up/down in insert mode unless popup menu is visible
vim.keymap.set("i", "<Up>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-o>k"
  else
    return "<Up>"
  end
end, { expr = true, silent = true })

vim.keymap.set("i", "<Down>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-o>j"
  else
    return "<Down>"
  end
end, { expr = true, silent = true })

-- make cntrl-tab select option from menu
vim.keymap.set("i", "<Space>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>" -- enter key without newline
  else
    return "<Space>"
  end
end, { expr = true, silent = true })
