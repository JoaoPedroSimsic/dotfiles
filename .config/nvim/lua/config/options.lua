vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true

vim.o.guicursor = "n-v-c:block"
vim.o.guicursor = vim.o.guicursor .. ",i-c:block-blinkon1"
vim.o.guicursor = vim.o.guicursor .. ",r:block"

-- makes blade files load just as php
vim.api.nvim_create_autocmd("FileType", {
	pattern = "blade",
	callback = function()
		vim.cmd("syntax include @php syntax/php.vim")
		vim.cmd('syntax region phpCode start="@php" end="@endphp" contains=@php')
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		require("jdtls.jdtls_setup").setup()
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.java",
	callback = function()
		vim.fn.jobstart("./mvnw compile", { detach = true })
	end,
})

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
