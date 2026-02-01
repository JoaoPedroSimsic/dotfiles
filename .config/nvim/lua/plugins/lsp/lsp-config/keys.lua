local float_toggle = require("config.utils.float_toggle")

return {
	{
		"K",
		function()
			float_toggle.toggle("hover", vim.lsp.buf.hover)
		end,
		desc = "Toggle LSP Hover",
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
