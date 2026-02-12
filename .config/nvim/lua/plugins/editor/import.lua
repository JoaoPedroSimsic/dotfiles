return {
	"piersolenski/import.nvim",
	keys = require("lua.config.keymaps.editor.import"),
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		picker = "telescope",
		insert_at_top = true,
	},
}
