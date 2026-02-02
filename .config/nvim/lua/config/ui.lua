-- Cursor configuration
vim.o.guicursor = "n-v-c:block"
vim.o.guicursor = vim.o.guicursor .. ",i-c:block-blinkon1"
vim.o.guicursor = vim.o.guicursor .. ",r:block"

-- This makes the actual text in the buffer gray when it's an error
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { fg = "#6272a4", italic = true })
-- This makes the virtual text/lines gray
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#6272a4" })

-- Make unreachable/unnecessary code gray and italic
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#6272a4", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#6272a4" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#6272a4" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#6272a4", underline = true })
