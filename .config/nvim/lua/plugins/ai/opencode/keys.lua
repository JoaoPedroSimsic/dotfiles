return {
	{
		"<leader>gg",
		function()
			require("opencode").toggle()
		end,
		mode = { "n", "t" },
		desc = "Toggle opencode",
	},
	{
		"<leader>gs",
		function()
			require("opencode").ask("@this: ", { submit = true })
		end,
		mode = { "n", "v" },
		desc = "Ask opencode…",
	},
	{
		"<leader>gb",
		function()
			require("opencode").ask("@buffer: ", { submit = true })
		end,
		mode = "n",
		desc = "Ask opencode about file…",
	},
	{
		"<leader>gn",
		function()
			require("opencode").select()
		end,
		mode = { "n", "x" },
		desc = "Execute opencode action…",
	},
	{
		"go",
		function()
			return require("opencode").operator("@this ")
		end,
		mode = { "n", "x" },
		expr = true,
		desc = "Add range to opencode",
	},
	{
		"goo",
		function()
			return require("opencode").operator("@this ") .. "_"
		end,
		mode = "n",
		expr = true,
		desc = "Add line to opencode",
	},
	{
		"W",
		function()
			require("opencode").command("session.half.page.up")
		end,
		mode = "n",
		desc = "Scroll opencode up",
	},
	{
		"S",
		function()
			require("opencode").command("session.half.page.down")
		end,
		mode = "n",
		desc = "Scroll opencode down",
	},
	{
		"<leader>gl",
		function()
			require("opencode").select_session()
		end,
		mode = "n",
		desc = "List/resume OpenCode sessions",
	},
	{
		"<leader>gq",
		function()
			require("plugins.ai.opencode.lifecycle").stop()
		end,
		mode = "n",
		desc = "Stop OpenCode cleanly",
	},
}
