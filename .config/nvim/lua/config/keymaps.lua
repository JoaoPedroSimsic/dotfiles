local map = vim.keymap.set

local builtin = require("telescope.builtin")
local dap = require("dap")
local dapui = require("dapui")

vim.g.mapleader = " "

--Switch window
vim.api.nvim_set_keymap('n', '<A-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-l>', '<C-w>l', { noremap = true })

--Telescope
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

--Neotree
map("n", "<leader>t", ":Neotree toggle<CR>", { noremap = true, silent = true })

--Lspconfig
map("n", "K", vim.lsp.buf.hover, {})
map("n", "gd", vim.lsp.buf.definition, {})
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

--luasnip


--none-ls
map("n", "<leader>gf", vim.lsp.buf.format, {})

--dap
map("n", "<Leader>b", dap.toggle_breakpoint, {})
map("n", "<leader>c", dap.continue, {})
map("n", "<Leader>si", dap.step_into, { desc = "Step Into" })
map("n", "<Leader>so", dap.step_over, { desc = "Step Over" })
map("n", "<Leader>st", dap.step_out, { desc = "Step Out" })
map("n", "<Leader>dx", dap.terminate, { desc = "Terminate" })
map("n", "<Leader>du", dapui.toggle, { desc = "Toggle UI" })

--trouble
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })

--bufferline
map('n', '<A-Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
map('n', '<C-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
map('n', '<C-n>', ':enew<CR>', { noremap = true, silent = true })
map('n', '<C-d>', ':bd<CR>', { noremap = true, silent = true })
map('n', 'D', ':bd!<CR>', { noremap = true, silent = true })

