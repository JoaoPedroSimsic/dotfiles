return {
	{
		"ramilito/kubectl.nvim",
		keys = require("config.keymaps.ui.kubectl"),
		dependencies = "saghen/blink.download",
		config = function()
			require("kubectl").setup()
		end,
	},
}
