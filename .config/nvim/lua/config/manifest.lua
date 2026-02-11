local M = {}

M.tools = {
	servers = {
		"lua_ls",
		"clangd",
		"html",
		"ts_ls",
		"cssls",
		"gopls",
		"prismals",
		"intelephense",
		"vue_ls",
		"dockerls",
		"docker_compose_language_service",
		"bashls",
		"jdtls",
		"lemminx",
		"pyright",
    "terraformls",
	},

	formatters = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },
		html = { "prettierd" },
		blade = { "blade-formatter" },
		c = { "clang_format" },
		java = { "google-java-format" },
	},

	linters = {
		javascript = { "eslint_d" },
		typescript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		python = { "pylint" },
	},
}

M.get_tools = function()
	local all = {}
	local seen = {}

	for _, list in pairs(M.tools) do
		for _, item in ipairs(list) do
			if not seen[item] then
				table.insert(all, item)
				seen[item] = true
			end
		end
	end
	return all
end

return M
