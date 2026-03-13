return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		enabled = true,
		render_modes = { "n", "c", "i", "v" },
		anti_conceal = {
			enabled = true,
		},
	},
}
