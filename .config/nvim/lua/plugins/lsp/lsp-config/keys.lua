return {
	{
		"K",
		vim.lsp.buf.hover,
		desc = "LSP Hover",
		mode = "n",
	},
	{
		"gd",
		vim.lsp.buf.definition,

		desc = "LSP Go to Definition",
		mode = "n",
	},
	{
		"<leader>ca",
		vim.lsp.buf.code_action,
		desc = "LSP Code Action",
		mode = { "n", "v" },
	},
}
