-- core/keymaps.lua
local keymap = vim.keymap.set

-- Space as leader key
vim.g.mapleader = " "

vim.api.nvim_set_keymap('i', '<C-H>', '<C-w>', { noremap = true })

keymap("i", "<C-BS>", "C-w", {noremap=true})
keymap("i", "<C-q>", "<ESC>")
keymap("n", "<leader>w", ":w<CR>")     -- save file
keymap("n", "<leader>qq", ":q<CR>")     -- quit
keymap("n", "<C-h>", "b")
keymap("n", "<C-l>", "w")
keymap("n", "<C-j>", "5j")
keymap("n", "<C-k>", "5k")
keymap("n", "<leader>o", "o<Esc>")
keymap("n", "<leader>O", "O<Esc>")
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
keymap("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>") -- search file for word
keymap("n", "<leader><C-f>", "<cmd>NvimTreeOpen<cr>")
keymap("n", "<leader><C-x>", "<cmd>NvimTreeClose<cr>")
keymap("n", "<leader><C-t>", "<cmd>tabnew<cr>")
keymap("n", "<leader><C-l>", "<cmd>tabn<cr>")
keymap("n", "<leader><C-h>", "<cmd>tabp<cr>")
-- For easier text wrapping
local wrap = require('tenaille').wrap

vim.keymap.set('v', '"', function() wrap({ '"', '"' }) end)
vim.keymap.set('v', "'", function() wrap({ "'", "'" }) end)
vim.keymap.set('v', '`', function() wrap({ '`', '`' }) end)
vim.keymap.set('v', '(', function() wrap({ '(', ')' }) end)
vim.keymap.set('v', '[', function() wrap({ '[', ']' }) end)
vim.keymap.set('v', '{', function() wrap({ '{', '}' }) end)
vim.keymap.set('v', '<', function() wrap({ '<', '>' }) end)

-- Replace symbol in file
vim.keymap.set('n', '<Leader>r', function()
  local word = vim.fn.expand('<cword>')
  local repl = vim.fn.input('Replace "'..word..'" with: ')
  word = vim.fn.escape(word, '\\/')
  repl = vim.fn.escape(repl, '\\/')
  vim.cmd("normal! mz")  -- mark current position
  vim.cmd(string.format('%%s/\\V\\<%s\\>/%s/g', word, repl))
  vim.cmd("normal! `z") -- jump back to mark
end, { noremap=true, silent=true })

vim.keymap.set(
  "",
  "<Leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)

