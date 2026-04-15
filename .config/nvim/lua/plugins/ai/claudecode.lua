return {
	"coder/claudecode.nvim",
	cmd = { "ClaudeCode", "ClaudeCodeChat" },
	keys = {
		{
			"<leader>gg",
			"<cmd>ClaudeCode<cr>",
			mode = { "n", "t" },
		},
		{
			"<leader>gf",
			"<cmd>ClaudeCodeFocus<cr>",
			mode = "n",
		},
		{
			"<leader>gq",
			"<cmd>ClaudeCodeStop<cr>",
			mode = "n",
		},
		{
			"<leader>ga",
			"<cmd>ClaudeCodeDiffAccept<cr>",
		},
		{
			"<leader>gd",
			"<cmd>ClaudeCodeDiffDeny<cr>",
		},
		{
			"<leader>gl",
			function()
				vim.cmd("ClaudeCode")
				local attempts = 0
				local max_attempts = 20
				local timer = vim.uv.new_timer()
				timer:start(
					50,
					50,
					vim.schedule_wrap(function()
						attempts = attempts + 1
						local mode = vim.api.nvim_get_mode().mode
						if mode == "t" then
							timer:stop()
							timer:close()
							local keys = vim.api.nvim_replace_termcodes("/resume<CR>", true, false, true)
							vim.api.nvim_feedkeys(keys, "t", false)
						elseif attempts >= max_attempts then
							timer:stop()
							timer:close()
						end
					end)
				)
			end,
			mode = "n",
		},
	},
	config = function()
		require("claudecode").setup({
			terminal_cmd = "claude",
			focus_after_send = true,
			track_selection = true,
			terminal = {
				split_side = "right",
				split_width_percentage = 0.30,
				provider = "native",
				show_native_term_exit_tip = false,
				auto_close = true,
				env = {},
				snacks_win_opts = {},
			},
			diff_opts = {
				layout = "vertical",
				open_in_new_tab = true,
				keep_terminal_focus = false,
				open_in_current_tab = false,
				hide_terminal_in_new_tab = true,
				on_new_file_reject = "close_window",
			},
		})

		vim.api.nvim_create_autocmd("TermOpen", {
			group = vim.api.nvim_create_augroup("ClaudeTerminalClose", { clear = false }),
			pattern = "term://*claude*",
			callback = function(ev)
				vim.bo[ev.buf].bufhidden = "wipe"
				vim.bo[ev.buf].modified = false

				local opts = { buffer = true, noremap = true, silent = true }

				vim.keymap.set("t", "<C-c>", [[<C-\><C-n>]], opts)
			end,
		})

		vim.api.nvim_create_autocmd("TermClose", {
			group = vim.api.nvim_create_augroup("ClaudeTerminalClose", { clear = false }),
			pattern = "term://*claude*",
			callback = function(ev)
				vim.bo[ev.buf].modified = false
			end,
		})
	end,
}
