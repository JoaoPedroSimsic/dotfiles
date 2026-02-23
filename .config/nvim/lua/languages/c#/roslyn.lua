return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = {
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			},
		},
	},
	config = function()
		require("roslyn").setup({
			args = {
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
				"--stdio",
			},
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
	end,
}
