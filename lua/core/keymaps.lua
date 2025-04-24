-- core/keymaps.lua

local keymap = vim.keymap.set

-- Space as leader key
vim.g.mapleader = " "

keymap("n", "<leader>w", ":w<CR>")     -- save file
keymap("n", "<leader>q", ":q<CR>")     -- quit

