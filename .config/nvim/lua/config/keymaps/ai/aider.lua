return {
	{
		"<leader>gg",
		function()
			require("utils.aider").toggle()
		end,
		mode = { "n", "t" },
		desc = "Toggle aider",
	},
	{
		"<leader>gm",
		"<cmd>AiderAddModifiedFiles<CR>",
		mode = { "n" },
		desc = "Add modified files to aider",
	},
}
