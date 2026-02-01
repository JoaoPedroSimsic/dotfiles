return {
	"NickvanDyke/opencode.nvim",
	lazy = true,
	cmd = { "OpenCode" },
	keys = require("plugins.ai.opencode.keys"),
	dependencies = {
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Provider configuration - optimized for Snacks terminal
			provider = {
				enabled = "snacks",
				snacks = {
					win = {
						position = "right", -- Position terminal on right side
						size = 0.4, -- Take 40% of screen width
						border = "rounded", -- Rounded borders for aesthetics
					},
					args = {
						"--port",
						"auto", -- Auto-assign port
					},
				},
			},
			-- Event configuration with real-time reload
			events = {
				enabled = true,
				reload = true, -- Enable auto-reload on file changes
				permissions = {
					enabled = true,
					idle_delay_ms = 200, -- Faster permission prompts
				},
			},
			-- UI customization for ask input
			ask = {
				prompt = "󰚩 Ask OpenCode: ",
				blink_cmp_sources = { "opencode", "buffer" },
				snacks = {
					icon = "󰚩 ",
					win = {
						title = " OpenCode ",
						title_pos = "center", -- Center the title
						relative = "cursor",
						row = -3,
						col = 0,
						border = "rounded", -- Rounded borders
						width = 80, -- Fixed width for better readability
					},
					style = {
						backdrop = 60, -- Dim background slightly
					},
				},
			},
		}

		vim.o.autoread = true

		-- Event automation
		vim.api.nvim_create_autocmd("User", {
			pattern = "OpencodeEvent:session.idle",
			callback = function()
				vim.notify("OpenCode finished responding", vim.log.levels.INFO)
			end,
			desc = "Notify when OpenCode finishes responding",
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "OpencodeEvent:edit.start",
			callback = function()
				-- Auto-save all buffers before OpenCode makes edits
				vim.cmd("silent! wall")
			end,
			desc = "Auto-save buffers before OpenCode edits",
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "OpencodeEvent:error",
			callback = function(args)
				local event = args.data.event
				vim.notify("OpenCode error: " .. (event.message or "Unknown"), vim.log.levels.ERROR)
			end,
			desc = "Notify on OpenCode errors",
		})
	end,
}
