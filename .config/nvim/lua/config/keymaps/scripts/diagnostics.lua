local map = vim.keymap.set
local float_toggle = require("config.utils.float_toggle")

map("n", "<leader>e", function()
	float_toggle.toggle("diagnostic", function()
		return vim.diagnostic.open_float(nil, { focusable = false })
	end)
end, { desc = "Toggle diagnostic float" })
