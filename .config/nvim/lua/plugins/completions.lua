return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},

	{
		"hrsh7th/nvim-cmp",
		optional = true,
		dependencies = { "saadparwaiz1/cmp_luasnip" },
		opts = function(_, opts)
			-- Initialize sources table if it's nil
			opts.sources = opts.sources or {}

			opts.snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			}

			-- Add 'luasnip' source if not already present
			table.insert(opts.sources, { name = "luasnip" })
		end,
		-- stylua: ignore
		keys = {
			{ "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
			{ "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
		},
	},

	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		run = "make install_jsregexp",
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})
				end,
			},
		},
		opts = function()
			-- Custom snippet setup (if necessary)
		end,
	},

	-- Custom LuaSnip and nvim-cmp setup
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-path" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Set up the completion engine with LuaSnip
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body) -- Expand snippet using luasnip
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					--["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = cmp.mapping(function()
						if cmp.visible() then
							if cmp.get_selected_entry() then
								-- If a completion item is selected, confirm the selection
								cmp.confirm({ select = true })
							else
								-- If no completion item is selected, simulate pressing Enter (new line)
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<CR>", true, true, true),
									"n",
									true
								)
							end
						else
							-- If cmp is not visible, behave like normal Enter (new line)
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
						end
					end, { "i", "s" }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip", options = { show_autosnippets = true } },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
