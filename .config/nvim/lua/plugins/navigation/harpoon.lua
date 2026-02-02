return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	keys = require("config.keymaps.navigation.harpoon"),
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("harpoon").setup({
			settings = {
				save_on_toggle = false,
				sync_on_ui_close = true,
        key = function ()
          return vim.loop.cwd()
        end
			},
		})
	end,
}
