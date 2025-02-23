-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

--allow to copy to clipboard
vim.o.clipboard = 'unnamedplus'

--enable rlative line number
vim.opt.number = true
vim.opt.relativenumber = true

lvim.plugins = {
  {
    "ribru17/bamboo.nvim",
    priority = 1000,
    config = function ()
      require("bamboo").setup({
        transparent = true,
        terminal_colors = true,
      })
      require("bamboo").load()
    end,
  },
}

lvim.colorscheme = "bamboo"
