local manifest = require("config.manifest")

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = manifest.get_tools(),
		auto_update = true,
		run_on_start = true,
	},
}
