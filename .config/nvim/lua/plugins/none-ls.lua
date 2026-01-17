return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			debug = true,
			timeout = 5000,
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.completion.spell,
				require("none-ls.diagnostics.eslint"),
				null_ls.builtins.formatting.prettier.with({
					filetypes = {
						"typescript",
						"typescriptreact",
						"javascript",
						"javascriptreact",
						"json",
						"css",
						"scss",
						"html",
					},
				}),
				null_ls.builtins.formatting.pint,
				null_ls.builtins.formatting.blade_formatter,
				null_ls.builtins.formatting.clang_format.with({
					filetypes = {
						"java",
						"c",
					},
				}),
			},
		})
	end,
}
