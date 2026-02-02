local map = vim.keymap.set

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "J", "mzJ`z")

map("x", "<leader>p", '"_dP', { noremap = true, silent = true })

map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set({ "n", "x" }, "<leader>s", function()
	local mode = vim.fn.mode()
	local search_text = ""

	if mode == "v" or mode == "V" or mode == "\22" then
		vim.cmd('normal! "vy') 
		search_text = vim.fn.getreg("v")
		search_text = vim.fn.escape(search_text, "\\/.*$^~[]")
	else
		search_text = vim.fn.expand("<cword>")
	end

	local cmd = string.format(":%s/\\<%s\\>/%s/gc", "%s", search_text, search_text)

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "c", true)
end, { desc = "Pre-fill substitution for selection or word, whole file" })
