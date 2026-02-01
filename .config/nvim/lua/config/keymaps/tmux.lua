-- Tmux-related keymaps
local map = vim.keymap.set

-- Create new window tmux-sessionizer
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer.sh<CR>")

-- Tmux cht.sh
map("n", "<C-q>", "<cmd>silent !tmux neww tmux-cht.sh<CR>")

-- Open NVim config
map("n", "<leader>vpp", "<cmd>silent !tmux neww nvim ~/.config/nvim/init.lua<CR>")
