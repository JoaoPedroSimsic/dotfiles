return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Register custom parser
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main", -- Or the correct branch if different
      },
      filetype = "blade",
    }

    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "php", "html", "blade" }, -- blade included here
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
