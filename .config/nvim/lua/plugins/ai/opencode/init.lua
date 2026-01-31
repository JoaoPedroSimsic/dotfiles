return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
		}

		vim.o.autoread = true

    require("plugins.ai.opencode.keys").setup()

	end,
}
