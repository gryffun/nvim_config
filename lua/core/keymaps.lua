-- core/keymaps.lua
local keymap = vim.keymap.set

-- Space as leader key
vim.g.mapleader = " "

vim.api.nvim_set_keymap('i', '<C-H>', '<C-w>', { noremap = true })

keymap("i", "C-BS", "C-w", {noremap=true})
keymap("n", "<leader>w", ":w<CR>")     -- save file
keymap("n", "<leader>qq", ":q<CR>")     -- quit 


