-- core/keymaps.lua
local keymap = vim.keymap.set

-- Space as leader key
vim.g.mapleader = " "

keymap("i", "<C-BS>", "C-w", {noremap=true})
keymap("i", "<C-q>", "<ESC>")
keymap("n", "<leader>w", ":w<CR>")     -- save file
keymap("n", "<leader>qq", ":q<CR>")     -- quit
keymap("n", "<C-j>", "5j")
keymap("n", "<C-k>", "5k")
keymap("n", "<leader>o", "o<Esc>")
keymap("n", "<leader>O", "O<Esc>")
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
keymap("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>") -- search file for word
keymap('n', '<leader>fr', "<cmd>Telescope lsp_references<cr>")
keymap("n", "<leader><C-f>", "<cmd>NvimTreeOpen<cr>")
keymap("n", "<leader><C-x>", "<cmd>NvimTreeClose<cr>")
keymap("n", "<leader><C-t>", "<cmd>tabnew<cr>")

-- For easier text wrapping
local wrap = require('tenaille').wrap
keymap('v', '"', function() wrap({ '"', '"' }) end)
keymap('v', "'", function() wrap({ "'", "'" }) end)
keymap('v', '`', function() wrap({ '`', '`' }) end)
keymap('v', '(', function() wrap({ '(', ')' }) end)
keymap('v', '[', function() wrap({ '[', ']' }) end)
keymap('v', '{', function() wrap({ '{', '}' }) end)
keymap('v', '<', function() wrap({ '<', '>' }) end)

-- Replace symbol in file
keymap('n', '<Leader>r', function()
  local word = vim.fn.expand('<cword>')
  local repl = vim.fn.input('Replace "'..word..'" with: ')
  word = vim.fn.escape(word, '\\/')
  repl = vim.fn.escape(repl, '\\/')
  vim.cmd("normal! mz")  -- mark current position
  vim.cmd(string.format('%%s/\\V\\<%s\\>/%s/g', word, repl))
  vim.cmd("normal! `z") -- jump back to mark
end, { noremap=true, silent=true })

-- Move tabs with wrap around
keymap("n", "<C-l>", function()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  local next_tab = (current % total) + 1
  vim.cmd("tabnext " .. next_tab)
end)
keymap("n", "<C-h>", function()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  local prev_tab = (current - 2 + total) % total + 1
  vim.cmd("tabnext " .. prev_tab)
end)

