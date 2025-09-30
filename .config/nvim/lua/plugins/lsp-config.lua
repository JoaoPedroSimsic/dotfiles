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
				"dockerls",
				"docker_compose_language_service",
				"bashls",
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

			vim.lsp.config("ts_ls", {
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

			vim.lsp.config("dockerls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("dockerls")

			vim.lsp.config("docker_compose_language_service", {
				capabilities = capabilities,
			})
			vim.lsp.enable("docker_compose_language_service")

			vim.lsp.config("bashls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("bashls")

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
