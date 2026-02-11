return {
	"zbirenbaum/copilot.lua",
	enabled = false,
	event = "VeryLazy",
	keys = require("config.keymaps.ai.copilot"),
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
