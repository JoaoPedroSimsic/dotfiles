return {
	"echasnovski/mini.nvim",
	version = false,
	lazy = false,
	keys = require("config.keymaps.editor.mini"),
	config = function()
		require("mini.move").setup()
		require("mini.pairs").setup()
		require("mini.cursorword").setup()
		require("mini.files").setup()
		require("mini.ai").setup()
		require("mini.comment").setup()
		require("mini.splitjoin").setup()
		require("mini.surround").setup()
		require("mini.cmdline").setup()
		require("mini.indentscope").setup()
		require("mini.notify").setup()
	end,
}
