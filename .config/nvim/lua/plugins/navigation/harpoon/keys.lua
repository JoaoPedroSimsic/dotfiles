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
			require("harpoon"):list():select(1)
		end,
		desc = "Harpoon Navigate to File 1",
    mode = "n",
	},
	{
		"<M-2>",
		function()
			require("harpoon"):list():select(2)
		end,
		desc = "Harpoon Navigate to File 2",
    mode = "n",
	},
	{
		"<M-3>",
		function()
			require("harpoon"):list():select(3)
		end,
		desc = "Harpoon Navigate to File 3",
    mode = "n",
	},
	{
		"<M-4>",
		function()
			require("harpoon"):list():select(4)
		end,
		desc = "Harpoon Navigate to File 4",
    mode = "n",
	},
	{
		"<M-5>",
		function()
			require("harpoon"):list():select(5)
		end,
		desc = "Harpoon Navigate to File 5",
    mode = "n",
	},
	{
		"<M-6>",
		function()
			require("harpoon"):list():select(6)
		end,
		desc = "Harpoon Navigate to File 6",
    mode = "n",
	},
}
