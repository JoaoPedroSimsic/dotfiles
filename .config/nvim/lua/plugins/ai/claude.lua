return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	keys = {
		{ "<leader>gn", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>ga", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>gr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>gC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>gm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>gb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>gs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>gs",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		{ "<leader>gh", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>gf", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
	opts = {
		diff_opts = {
			auto_close_on_accept = true,
      --open_in_current_tab = true,
		},
	},
}
