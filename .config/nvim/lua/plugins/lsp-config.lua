return  {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "html", "ts_ls", "cssls" },
		},
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities
			})
			lspconfig.html.setup({
				capabilities = capabilities
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities
			})
			lspconfig.cssls.setup({
				capabilities = capabilities
			})
		end,
	},
}

