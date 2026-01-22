-- return {
-- 	require("lazy").setup({
--   "neanias/everforest-nvim",
--   version = false,
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("everforest").setup({
-- 				background = "hard",
--     })
-- 			vim.cmd("colorscheme everforest")
--   end,
-- })
-- }

return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup()
		vim.cmd("colorscheme cyberdream")
	end,
}
