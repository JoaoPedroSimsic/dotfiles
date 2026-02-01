return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			-- Linters
			"eslint_d",
			"ruff",
			-- Formatters
			"prettierd",
			"stylua",
			"black",
			"clang-format",
			"google-java-format",
		},
		auto_update = true,
		run_on_start = true,
	},
}
