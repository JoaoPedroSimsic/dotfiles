return {
  enabled = false,
	"nvim-telekasten/telekasten.nvim",
	config = function()
		require("telekasten").setup({
			home = vim.fn.expand("~/proj/vault"),
		})
	end,
}
