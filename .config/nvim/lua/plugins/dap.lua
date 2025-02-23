return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			-- Mason setup with handlers
			require("mason").setup()
			require("mason-nvim-dap").setup({
				ensure_installed = { "js-debug-adapter" },
				handlers = {
					function(config)
						-- all sources with no handler get passed here
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})

			-- DAP UI setup
			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes",      size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks",      size = 0.25 },
							{ id = "watches",     size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl",    size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = vim.fn.resolve(
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug-adapter"
					),
					args = { "${port}" },
				},
			}

			-- JavaScript/Node configuration
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
					protocol = "inspector",
					console = "integratedTerminal",
				},
			}

			dap.configurations.typescript = dap.configurations.javascript

			-- Debug UI event handlers with error handling
			dap.listeners.after.event_initialized["dapui_config"] = function()
				vim.notify("Debug session started", vim.log.levels.INFO)
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				vim.notify("Debug session terminated", vim.log.levels.INFO)
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				vim.notify("Debug session exited", vim.log.levels.INFO)
				dapui.close()
			end

			-- Enhanced error logging
			dap.listeners.after.event_output["dapui_config"] = function(_, body)
				if body.category == "stderr" then
					vim.notify("Debug error: " .. body.output, vim.log.levels.ERROR)
				end
			end

			-- Error handling for failed connections
			dap.listeners.after.event_error["dapui_config"] = function(_, err)
				vim.notify("Debug error: " .. vim.inspect(err), vim.log.levels.ERROR)
			end

			-- Keymaps
			vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>c", dap.continue, { desc = "Continue" })
			vim.keymap.set("n", "<Leader>si", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<Leader>so", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<Leader>st", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<Leader>dx", dap.terminate, { desc = "Terminate" })
			vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle UI" })
		end,
	},
}
