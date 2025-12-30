vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true  

vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true

--turns the insert mode cursor as a blinking block
vim.o.guicursor = "n-v-c:block"  -- Normal, Visual, and Command mode
vim.o.guicursor = vim.o.guicursor .. ",i-c:block-blinkon1"  -- Insert mode with blinking block cursor
vim.o.guicursor = vim.o.guicursor .. ",r:block"  -- Replace mode with block cursor

-- makes blade files load just as php
vim.api.nvim_create_autocmd("FileType", {
  pattern = "blade",
  callback = function()
    vim.cmd("syntax include @php syntax/php.vim")
    vim.cmd("syntax region phpCode start=\"@php\" end=\"@endphp\" contains=@php")
  end,
})
