return {
	"NickvanDyke/opencode.nvim",
	lazy = true,
	cmd = { "OpenCode", "OpenCodeChat" },
	keys = require("plugins.ai.opencode.keys"),
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
