local manifest = require("config.manifest")

return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = manifest.tools.servers,
		automatic_enable = {
			exclude = {
				"jdtls",
			},
		},
	},
}
