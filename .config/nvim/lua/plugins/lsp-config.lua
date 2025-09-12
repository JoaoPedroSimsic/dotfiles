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
			ensure_installed = { "lua_ls", "clangd", "html", "ts_ls", "cssls", "gopls", "prismals", "intelephense" },
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
			lspconfig.clangd.setup({
				capabilities = capabilities
			})
			lspconfig.html.setup({
				capabilities = capabilities
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				flags = { allow_incremental_sync = false },
			})
			lspconfig.cssls.setup({
				capabilities = capabilities
			})
			lspconfig.gopls.setup({
				capabilities = capabilities
			})
			lspconfig.prismals.setup({
				capabilities = capabilities
			})
			lspconfig.intelephense.setup({
				capabilities = capabilities
			})

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},
}
