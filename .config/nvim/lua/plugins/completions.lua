return {
  {
    "hrsh7th/cmp-nvim-lsp",
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
        end,
      },
    },
    opts = function()
      -- Custom snippet setup (if necessary)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function()
            if cmp.visible() then
              if cmp.get_selected_entry() then
                cmp.confirm({ select = true })
              else
                vim.api.nvim_feedkeys(
                  vim.api.nvim_replace_termcodes("<CR>", true, true, true),
                  "n",
                  true
                )
              end
            else
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<CR>", true, true, true),
                "n",
                true
              )
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
	--				{ name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
