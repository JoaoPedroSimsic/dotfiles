return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local parsers = require("nvim-treesitter.parsers")

		-- 1. Register custom parser (Blade)
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

		-- 2. Register the language mapping
		vim.treesitter.language.register("blade", { "blade" })

		-- 3. Install your preferred parsers (The new 'setup')
		-- This replaces 'ensure_installed'
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

		-- 4. Enable Highlighting & Indent (The New Core Way)
		-- The rewrite prefers using Autocmds or ftplugins
		vim.api.nvim_create_autocmd("FileType", {
			-- Add the filetypes you want treesitter to handle
			pattern = { "lua", "php", "blade", "javascript", "typescript", "c_sharp" },
			callback = function(args)
				-- Check file size like you did before
				local max_filesize = 100 * 1024
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
				if ok and stats and stats.size > max_filesize then
					return
				end

				-- Enable Highlighting
				vim.treesitter.start(args.buf)
				-- Enable Indentation
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- 5. Custom filetype detection
		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})
	end,
}
