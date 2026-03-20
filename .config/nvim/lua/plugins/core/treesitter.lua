return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Try to configure blade parser (optional, may not work with newer treesitter)
		local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
		if ok_parsers and parsers.get_parser_configs then
			local ok_config, parser_config = pcall(parsers.get_parser_configs)
			if ok_config and parser_config then
				parser_config.blade = {
					install_info = {
						url = "https://github.com/EmranMR/tree-sitter-blade",
						files = { "src/parser.c" },
						branch = "main",
					},
					filetype = "blade",
				}
			end
		end

		local ok_configs, configs = pcall(require, "nvim-treesitter.configs")
		if not ok_configs then
			vim.notify("nvim-treesitter.configs not available yet", vim.log.levels.WARN)
			return
		end

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
