return {
	"felixcuello/neovim-cursor",
	keys = require("config.keymaps.ai.init"),
	config = function()
		require("neovim-cursor").setup({
			command = "agent",
			split = {
				position = "right",
				size = 0.4,
			},
		})
	end,
}
