local manifest = require("config.manifest")

return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	keys = require("config.keymaps.formatter.conform"),
	opts = {
		formatters_by_ft = manifest.tools.formatters,
		formatters = {
			["google-java-format"] = {
				command = "google-java-format",
			},
		},
	},
}
