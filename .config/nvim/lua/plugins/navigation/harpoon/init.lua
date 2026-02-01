return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	keys = require("plugins.navigation.harpoon.keys"),
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("harpoon").setup({
			settings = {
				save_on_toggle = false,
				sync_on_ui_close = true,
			},
		})
	end,
}
