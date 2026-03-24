-- dotfiles/.config/nvim/lua/config/theme.lua.template
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "dynamic_theme"

-- 1. Standard UI and Editor
vim.api.nvim_set_hl(0, "Normal", { fg = "#ff6600", bg = "#0a0400" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#ff6600", bg = "#0a0400" }) -- Floating windows
vim.api.nvim_set_hl(0, "LineNr", { fg = "#471d00" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#471d00" }) -- Or a very dark gray/surface color
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff9c59", bold = true })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#0a0400" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#471d00" })

-- 2. Standard Syntax & Treesitter
vim.api.nvim_set_hl(0, "@variable", { fg = "#ff6600" })
vim.api.nvim_set_hl(0, "@function", { fg = "#ff9c59" })
vim.api.nvim_set_hl(0, "@keyword", { fg = "#ff9c59", bold = true })
vim.api.nvim_set_hl(0, "@string", { fg = "#ff6600" })
vim.api.nvim_set_hl(0, "@number", { fg = "#ff9c59" })
vim.api.nvim_set_hl(0, "@operator", { fg = "#471d00" })
vim.api.nvim_set_hl(0, "@type", { fg = "#ff9c59" })
vim.api.nvim_set_hl(0, "@property", { fg = "#ff6600" })
vim.api.nvim_set_hl(0, "@punctuation", { fg = "#471d00" })
vim.api.nvim_set_hl(0, "@constructor", { fg = "#ff9c59" })

-- 3. Plugins
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#471d00" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#471d00" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = "#ff6600", bg = "#0a0400" })
