return {
  {
    "catppuccin/nvim",
    opts = {
      transparent_background = true,
    },
  },
  {
    "xero/evangelion.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("evangelion")
    end,
  },
}
