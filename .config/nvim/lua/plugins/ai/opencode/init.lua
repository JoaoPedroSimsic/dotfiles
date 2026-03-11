return {
	"NickvanDyke/opencode.nvim",
	lazy = true,
  commit = "849a5f63514667e63318521330f28acaf13a4125",
	cmd = { "OpenCode", "OpenCodeChat" },
	keys = require("config.keymaps.ai.init"),
	dependencies = {
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		require("plugins.ai.opencode.config")

		require("plugins.ai.opencode.events").setup()

		require("plugins.ai.opencode.session-management").setup()

		require("plugins.ai.opencode.lifecycle").setup()
	end,
}
