return {
	"crnvl96/lazydocker.nvim",
  keys = require("plugins.ui.lazydocker.keys"),
  lazy = true,
	config = function()
		require("lazydocker").setup({
			window = {
				settings = {
					width = 0.900,
					height = 0.900,
					border = "rounded",
					relative = "editor",
				},
			},
		})
	end,
}
