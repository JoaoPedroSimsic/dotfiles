vim.o.guicursor = "n-v-c:block"
vim.o.guicursor = vim.o.guicursor .. ",i-c:block-blinkon1"
vim.o.guicursor = vim.o.guicursor .. ",r:block"

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a" })

vim.opt.colorcolumn = "100,101"

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { fg = "#6272a4", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#6272a4" })

vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#6272a4", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#6272a4" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#6272a4" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#6272a4", underline = true })
