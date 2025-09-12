return {
	"CRAG666/code_runner.nvim",
	config = function()
		require("code_runner").setup({
			mode = "term",
			startinsert = true, 
			filetype = {
				javascript = "node",
				lua = "lua",
				typescript = "tsc && node dist/index.js",
			},
		})
	end,
}
