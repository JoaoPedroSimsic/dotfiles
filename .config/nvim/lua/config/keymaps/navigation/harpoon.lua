local function select_and_center(index)
	require("harpoon"):list():select(index)
	vim.cmd("normal! zz")
end

return {
	{
		"<leader>a",
		function()
			require("harpoon"):list():add()
		end,
		desc = "Harpoon Add File",
		mode = "n",
	},
	{
		"<C-e>",
		function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Harpoon Toggle Menu",
		mode = "n",
	},
	{
		"<M-1>",
		function()
			select_and_center(1)
		end,
		desc = "Harpoon Navigate to File 1",
		mode = "n",
	},
	{
		"<M-2>",
		function()
			select_and_center(2)
		end,
		desc = "Harpoon Navigate to File 2",
		mode = "n",
	},
	{
		"<M-3>",
		function()
			select_and_center(3)
		end,
		desc = "Harpoon Navigate to File 3",
		mode = "n",
	},
	{
		"<M-4>",
		function()
			select_and_center(4)
		end,
		desc = "Harpoon Navigate to File 4",
		mode = "n",
	},
	{
		"<M-5>",
		function()
			select_and_center(5)
		end,
		desc = "Harpoon Navigate to File 5",
		mode = "n",
	},
	{
		"<M-6>",
		function()
			select_and_center(6)
		end,
		desc = "Harpoon Navigate to File 6",
		mode = "n",
	},
}
