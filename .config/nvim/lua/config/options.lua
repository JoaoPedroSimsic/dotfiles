-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Colors
vim.opt.termguicolors = true

-- Reduce timeout for leader key
vim.opt.timeoutlen = 300

vim.opt.updatetime = 250

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "d", '"_d', opts)
vim.keymap.set("n", "D", '"_D', opts)
vim.keymap.set("n", "c", '"_c', opts)
vim.keymap.set("n", "C", '"_C', opts)
vim.keymap.set("n", "x", '"_x', opts)
vim.keymap.set("n", "X", '"_X', opts)

vim.keymap.set("v", "d", '"_d', opts)
vim.keymap.set("v", "c", '"_c', opts)
vim.keymap.set("v", "x", '"_x', opts)
