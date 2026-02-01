local map = vim.keymap.set

vim.g.mapleader = " "

-- Open Netrw
map("n", "<leader>pv", vim.cmd.Ex)

-- Moves select blocks around
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Improves navigation by centering the cursor
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Joins the line below with the current line
map("n", "J", "mzJ`z")

-- Improves search navigation by centering it
map("n", "n", "nzzzv", { noremap = true, silent = true })
map("n", "N", "Nzzzv", { noremap = true, silent = true })

-- Paste without losing register
map("x", "<leader>p", '"_dP', { noremap = true, silent = true })

-- Copy to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

-- Delete without overwriting clipboard
map({ "n", "v" }, "<leader>d", [["_d]])

-- Create new window tmux-sessionizer
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer.sh<CR>")

map("n", "<C-q>", "<cmd>silent !tmux neww tmux-cht.sh<CR>")

-- Moves to quickfix and center the screen
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Same as before but in location list
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Replace word under cursor

vim.keymap.set({ "n", "x" }, "<leader>s", function()
	local mode = vim.fn.mode()
	local search_text = ""

	if mode == "v" or mode == "V" or mode == "\22" then
		vim.cmd('normal! "vy') -- yank visual selection into register v
		search_text = vim.fn.getreg("v")
		search_text = vim.fn.escape(search_text, "\\/.*$^~[]")
	else
		search_text = vim.fn.expand("<cword>")
	end

	-- Always do substitution on the whole file (% range)
	local cmd = string.format(":%s/\\<%s\\>/%s/gc", "%s", search_text, search_text)

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "c", true)
end, { desc = "Pre-fill substitution for selection or word, whole file" })

-- map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gcI<Left><Left><Left>]])

-- Open NVim config
map("n", "<leader>vpp", "<cmd>silent !tmux neww nvim ~/.config/nvim/init.lua<CR>")

vim.api.nvim_set_keymap("n", "<Up>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Down>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Left>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Right>", "<Nop>", { noremap = true })

