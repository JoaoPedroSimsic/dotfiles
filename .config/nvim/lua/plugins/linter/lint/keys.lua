return {
	{
		"<leader>ll",
		function()
			require("lint").try_lint()
		end,
		desc = "Lint File",
		mode = "n",
	},
}
