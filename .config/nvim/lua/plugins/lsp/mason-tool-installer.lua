return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			"eslint_d",
			"ruff",
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
