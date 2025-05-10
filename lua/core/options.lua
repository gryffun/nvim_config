-- core/options.lua

local opt = vim.opt

opt.number = true          -- show line numbers
opt.relativenumber = false -- relative line numbers
opt.tabstop = 4            -- 4 spaces per tab
opt.shiftwidth = 4         -- indentation levels
opt.expandtab = true       -- convert tabs to spaces
opt.smartindent = true     -- auto indent new lines
opt.wrap = true -- no line wrapping
opt.clipboard = "unnamedplus"  -- system clipboard
opt.cursorline = true -- big underline
opt.mouse = 'a' -- enable mouse in certain parts of vim. 'a' for all
