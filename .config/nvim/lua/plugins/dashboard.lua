return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		local db = require("dashboard")
		db.setup({
			theme = "doom",
			config = {
				header = {
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                     ]],
					[[       ████ ██████           █████      ██                     ]],
					[[      ███████████             █████                             ]],
					[[      █████████ ███████████████████ ███   ███████████   ]],
					[[     █████████  ███    █████████████ █████ ██████████████   ]],
					[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
					[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
					[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
				}, --your header
				center = {
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "New File",
						group = "Label",
						action = "enew",
						key = "n",
					},

					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Find Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Search",
						group = "Label",
						action = "Telescope live_grep",
						key = "s",
					},
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Recent Files",
						group = "Label",
						action = "Telescope oldfiles",
						key = "r",
					},
					{
						icon = "󰒲",
						icon_hl = "@variable",
						desc = " Open Lazy",
						group = "Label",
						action = "Lazy",
						key = "l",
					},
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Configurations",
						group = "Label",
						action = "Telescope find_files cwd=~/.config/nvim",
						key = "c",
					},
				},
				footer = {}, --your footer
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
