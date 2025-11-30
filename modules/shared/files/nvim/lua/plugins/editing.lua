return {
  {
    "andrewferrier/debugprint.nvim",

    dependencies = {
      "echasnovski/mini.nvim", -- Optional: Needed for line highlighting (full mini.nvim plugin)
      -- ... or ...
      "echasnovski/mini.hipatterns", -- Optional: Needed for line highlighting ('fine-grained' hipatterns plugin)

      "ibhagwan/fzf-lua", -- Optional: If you want to use the `:Debugprint search` command with fzf-lua
      "nvim-telescope/telescope.nvim", -- Optional: If you want to use the `:Debugprint search` command with telescope.nvim
      "folke/snacks.nvim", -- Optional: If you want to use the `:Debugprint search` command with snacks.nvim
    },

    lazy = false, -- Required to make line highlighting work before debugprint is first used
    version = "*", -- Remove if you DON'T want to use the stable version
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
        keys = {
          { "<leader>o", "<cmd>Navbuddy<cr>", desc = "Nav" },
        },
      },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Uncomment whichever supported plugin(s) you use
      -- "nvim-tree/nvim-tree.lua",
      -- "nvim-neo-tree/neo-tree.nvim",
      -- "simonmclean/triptych.nvim"
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  -- Go to definition in popup
  {
    "WilliamHsieh/overlook.nvim",
    opts = {},
    
    -- stylua: ignore
    keys = {
      { "<leader>pd", function() require("overlook.api").peek_definition() end, desc = "Peek definition" },
      { "<leader>pp", function() require("overlook.api").peek_cursor() end, desc = "Peek cursor" },
      { "<leader>pu", function() require("overlook.api").restore_popup() end, desc = "Restore last popup" },
      { "<leader>pU", function() require("overlook.api").restore_all_popups() end, desc = "Restore all popups" },
      { "<leader>pc", function() require("overlook.api").close_all() end, desc = "Close all popups" },
      { "<leader>ps", function() require("overlook.api").open_in_split() end, desc = "Open popup in split" },
      { "<leader>pv", function() require("overlook.api").open_in_vsplit() end, desc = "Open popup in vsplit" },
      { "<leader>pt", function() require("overlook.api").open_in_tab() end, desc = "Open popup in tab" },
      { "<leader>po", function() require("overlook.api").open_in_original_window() end, desc = "Open popup in current window" },
    },
  },

  {
    "eero-lehtinen/oklch-color-picker.nvim",
    event = "VeryLazy",
    version = "*",
    keys = {
      -- One handed keymap recommended, you will be using the mouse
      {
        "<leader>v",
        function()
          require("oklch-color-picker").pick_under_cursor()
        end,
        desc = "Color pick under cursor",
      },
    },
    ---@type oklch.Opts
    opts = {},
  },
}
