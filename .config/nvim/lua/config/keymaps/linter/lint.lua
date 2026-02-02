return {
	{
		"<leader>f",
		function()
			require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 1000 })
		end,
		desc = "Format File",
		mode = "n",
	},
}
