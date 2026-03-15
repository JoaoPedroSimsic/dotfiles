return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		---@class parser_config
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		parser_config.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}

		local configs = require("nvim-treesitter.configs")
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
			},
			auto_install = true,
			sync_install = false,
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 100 * 1024
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
		})
	end,
}
