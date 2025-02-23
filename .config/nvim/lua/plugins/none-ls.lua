return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			debug = true,
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.completion.spell,
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.formatting.prettier,
			},
		})
	end,
}
