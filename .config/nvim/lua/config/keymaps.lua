local map = vim.keymap.set

local builtin = require("telescope.builtin")
local dap = require("dap")

vim.g.mapleader = " "

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

--none-ls
map("n", "<leader>gf", vim.lsp.buf.format, {})

--dap
--map("n", "<Leader>b", dap.toggle_breakpoint, {})
--map("n", "<leader>c", dap.continue, {})
