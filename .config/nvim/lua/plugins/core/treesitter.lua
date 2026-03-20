return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local parsers = require("nvim-treesitter.parsers")

		parsers.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
				revision = "HEAD",
			},
			filetype = "blade",
			tier = "community",
		}

		vim.treesitter.language.register("blade", { "blade" })

		require("nvim-treesitter").install({
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
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lua", "php", "blade", "javascript", "typescript", "c_sharp" },
			callback = function(args)
				local max_filesize = 100 * 1024
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
				if ok and stats and stats.size > max_filesize then
					return
				end

				vim.treesitter.start(args.buf)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})
	end,
}
