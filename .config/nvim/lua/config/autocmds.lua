-- Blade filetype configuration
vim.api.nvim_create_autocmd("FileType", {
	pattern = "blade",
	callback = function()
		vim.cmd("syntax include @php syntax/php.vim")
		vim.cmd('syntax region phpCode start="@php" end="@endphp" contains=@php')
	end,
})

-- Java filetype configuration
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

-- Auto-reload files on external changes
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
