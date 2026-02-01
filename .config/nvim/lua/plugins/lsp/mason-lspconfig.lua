return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"lua_ls",
			"clangd",
			"html",
			"ts_ls",
			"cssls",
			"gopls",
			"prismals",
			"intelephense",
			"vue_ls",
			"dockerls",
			"docker_compose_language_service",
			"bashls",
			"jdtls",
			"lemminx",
			"pyright",
		},
		automatic_enable = {
			exclude = {
				"jdtls",
			},
		},
	},
}
