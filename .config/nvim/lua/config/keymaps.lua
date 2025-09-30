local map = vim.keymap.set
local builtin = require("telescope.builtin")
local harpoon = require("harpoon")
harpoon:setup()

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

--Make it rain
map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- Harpoon
map("n", "<leader>a", function()
	harpoon:list():add()
end)

map("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

map("n", "<M-1>", function()
	harpoon:list():select(1)
end)

map("n", "<M-2>", function()
	harpoon:list():select(2)
end)

map("n", "<M-3>", function()
	harpoon:list():select(3)
end)

map("n", "<M-4>", function()
	harpoon:list():select(4)
end)

map("n", "<M-5>", function()
	harpoon:list():select(5)
end)

map("n", "<M-6>", function()
	harpoon:list():select(6)
end)

--Navigate vim panes better
-- map("n", "<c-k>", ":wincmd k<CR>", { noremap = true, silent = true })
-- map("n", "J", ":wincmd j<CR>", { noremap = true, silent = true })
-- map("n", "<c-h>", ":wincmd h<CR>", { noremap = true, silent = true })
-- map("n", "<c-l>", ":wincmd l<CR>", { noremap = true, silent = true })

--Switch window
--vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', { noremap = true })
--vim.api.nvim_set_keymap('n', '<leader>j', '<C-w>j',{ noremap = true })
--vim.api.nvim_set_keymap('n', '<leader>k', '<C-w>k',{ noremap = true })
--vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l',{ noremap = true })

--vim-tmux-navigator
map("n", "<C-h>", ":TmuxNavigateLeft<CR>", { noremap = true, silent = true })
map("n", "<C-j>", ":TmuxNavigateDown<CR>", { noremap = true, silent = true })
map("n", "<C-k>", ":TmuxNavigateUp<CR>", { noremap = true, silent = true })
map("n", "<C-l>", ":TmuxNavigateRight<CR>", { noremap = true, silent = true })

--Telescope
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

--Neotree
-- map("n", "<leader>t", ":Neotree toggle<CR>", { noremap = true, silent = true })

--Lspconfig
map("n", "K", vim.lsp.buf.hover, {})
map("n", "gd", vim.lsp.buf.definition, {})
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

--none-ls
map("n", "<leader>f", vim.lsp.buf.format, {})

--trouble
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })

--bufferline
map("n", "<A-Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })

--undotree
map("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })

--code_runner
map("n", "<leader>r", ":RunCode<CR>", { noremap = true, silent = true })

--Disabling arrow keys
vim.api.nvim_set_keymap("n", "<Up>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Down>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Left>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Right>", "<Nop>", { noremap = true })

vim.api.nvim_set_keymap("i", "<Up>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("i", "<Down>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("i", "<Left>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("i", "<Right>", "<Nop>", { noremap = true })

vim.api.nvim_set_keymap("v", "<Up>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Down>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Left>", "<Nop>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Right>", "<Nop>", { noremap = true })

-- Lazygit

map("n", "<leader>lg", ":LazyGit<CR>", { desc = "LazyGit" })
