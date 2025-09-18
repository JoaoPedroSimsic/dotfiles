return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"clangd",
				"html",
				"ts_ls",
				"cssls",
				"gopls",
				"prismals",
				"intelephense",
				"vue_ls",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("clangd", {
				capabilities = capabilities,
			})
			vim.lsp.enable("clangd")

			vim.lsp.config("html", {
				capabilities = capabilities,
			})
			vim.lsp.enable("html")

			vim.lsp.config("ts_ls", { -- was ts_ls
				capabilities = capabilities,
				flags = { allow_incremental_sync = false },
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
				},
			})
			vim.lsp.enable("ts_ls")

			vim.lsp.config("cssls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("cssls")

			vim.lsp.config("gopls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("gopls")

			vim.lsp.config("prismals", {
				capabilities = capabilities,
			})
			vim.lsp.enable("prismals")

			vim.lsp.config("intelephense", {
				capabilities = capabilities,
			})
			vim.lsp.enable("intelephense")

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
