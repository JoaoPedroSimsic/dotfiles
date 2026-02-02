return {
	{
		"<leader>ld",
		function()
			require("lazydocker").open()
		end,
		mode = "n",
		desc = "Open Lazydocker",
	},
}
