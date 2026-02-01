vim.g.opencode_opts = {
	provider = {
		enabled = "snacks",
		snacks = {
			win = {
				position = "right",
				size = 0.4,
				border = "rounded",
			},
			args = {
				"--port",
				"auto",
			},
		},
	},
	events = {
		enabled = true,
		reload = true,
		permissions = {
			enabled = true,
			idle_delay_ms = 200,
		},
	},
	ask = {
		prompt = "󰚩 Ask OpenCode: ",
		blink_cmp_sources = { "opencode", "buffer" },
		snacks = {
			icon = "󰚩 ",
			win = {
				title = " OpenCode ",
				title_pos = "center",
				relative = "cursor",
				row = -3,
				col = 0,
				border = "rounded",
				width = 80,
			},
			style = {
				backdrop = 60,
			},
		},
	},
}

vim.o.autoread = true
