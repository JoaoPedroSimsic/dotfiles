local manifest = require("config.manifest")

return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = manifest.get_tools(),
		automatic_enable = {
			exclude = {
				"jdtls",
			},
		},
	},
}
