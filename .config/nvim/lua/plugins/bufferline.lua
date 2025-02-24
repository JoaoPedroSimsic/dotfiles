return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "tiagovla/scope.nvim", config = true },
	},
	config = function()
		vim.opt.termguicolors = true
		require("scope").setup()
		require("bufferline").setup()
	end,
}
