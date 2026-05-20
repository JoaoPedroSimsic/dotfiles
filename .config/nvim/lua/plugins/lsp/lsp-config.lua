local manifest = require("config.manifest")

local get_rust_settings = function()
	return {
		settings = {
			["rust-analyzer"] = {
				cachePriming = {
					enable = false,
				},
				numThreads = 2,
				check = {
					extraArgs = { "--target-dir", "target/analyzer" },
				},
				completion = {
					autoimport = {
						enable = false,
					},
				},
				cargo = {
					features = {},
					extraEnv = {
						CARGO_BUILD_JOBS = "2",
					},
				},
			},
		},
	}
end

return {
	"neovim/nvim-lspconfig",
	lazy = false,
	keys = require("config.keymaps.lsp.lsp-config"),
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		for _, server in ipairs(manifest.tools.servers) do
			local server_opts = { capabilities = capabilities }

			if server == "rust_analyzer" then
				server_opts = vim.tbl_deep_extend("force", server_opts, get_rust_settings())
			end

			vim.lsp.config(server, server_opts)
			vim.lsp.enable(server)
		end
	end,
}
