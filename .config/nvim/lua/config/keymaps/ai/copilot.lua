return {
  {
  "<leader>l",
    function()
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        local termcode = vim.api.nvim_replace_termcodes("<leader>l", true, false, true)
        vim.api.nvim_feedkeys(termcode, "n", false)
      end
    end,
    mode = "i",
    desc = "Copilot Accept or Tab",
  },
}
