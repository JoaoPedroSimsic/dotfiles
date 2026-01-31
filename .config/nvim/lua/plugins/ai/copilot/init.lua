return {
	"zbirenbaum/copilot.lua",
	event = "VeryLazy",
	keys = require("plugins.ai.copilot.keys"),
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

