return {
	{
		"<C-a>",
		function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
		end,
		mode = "n",
	},
	{
		"<leader>m",
		function()
			MiniNotify.show_history()
		end,
		mode = "n",
	},
}
