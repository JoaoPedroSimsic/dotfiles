return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
	config = function()
		-- ---@class parser_config
		-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		--
		-- parser_config.blade = {
		-- 	install_info = {
		-- 		url = "https://github.com/EmranMR/tree-sitter-blade",
		-- 		files = { "src/parser.c" },
		-- 		branch = "main",
		-- 	},
		-- 	filetype = "blade",
		-- }

		local configs = require("nvim-treesitter")
		configs.setup({
			modules = {},
			ignore_install = {},

			ensure_installed = {
				"php",
				"html",
				"blade",
				"typescript",
				"angular",
				"java",
				"go",
				"css",
				"lua",
				"json",
				"python",
				"c_sharp",
				"razor",
				"markdown",
				"markdown_inline",
				"latex",
			},
		})
	end,
}
