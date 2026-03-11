return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	event = "VeryLazy",
	keys = require("config.keymaps.ai.init"),
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				accept = false,
			},
			panel = {
				enabled = false,
			},
			filetypes = {
				["*"] = true,
			},
		})
	end,
}
