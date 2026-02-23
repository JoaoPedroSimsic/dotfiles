return {
	{
		"<leader>lk",
		function()
			require("kubectl").toggle({ true })
		end,
		mode = "n",
		desc = "Open kubectl",
	},
}
