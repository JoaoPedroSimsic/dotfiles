return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
	keys = require("config.keymaps.navigation.telescope"),
	config = function()
		local actions_layout = require("telescope.actions.layout")

		require("telescope").setup({
			defaults = {
				preview = {
					hide_on_startup = true,
				},

				mappings = {
					i = {
						["<Tab>"] = actions_layout.toggle_preview,
					},
					n = {
						["<Tab>"] = actions_layout.toggle_preview,
					},
				},

				layout_strategy = "horizontal",

				layout_config = {
					width = 0.98,
					height = 0.92,

					horizontal = {
						preview_width = 0.6,
					},
				},

				file_ignore_patterns = {
					"node_modules/",
					"dist/",
					".git/",
					"build/",
					"target/",
          "public/",
					"%.lock",
				},

				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",

					"--hidden",
					"--no-ignore-vcs",

					"--glob=!.git/**",
					"--glob=!node_modules/**",
					"--glob=!dist/**",
					"--glob=!build/**",
					"--glob=!target/**",
				},
			},

			pickers = {
				find_files = {
					hidden = true,
					no_ignore = true,
					no_ignore_parent = true,
				},
			},

			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		require("telescope").load_extension("ui-select")
	end,
}
