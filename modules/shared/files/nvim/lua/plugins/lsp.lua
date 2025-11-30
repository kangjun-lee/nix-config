return {
  -- {
  --   -- none-ls is not installed by default
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     -- Don't use LazyVim's prettier extra plugin as it uses prettierd,
  --     -- which causes file trancation bug:
  --     -- https://github.com/jose-elias-alvarez/null-ls.nvim/discussions/1609
  --     table.insert(opts.sources, nls.builtins.formatting.prettier)
  --   end,
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
      -- The below is to ensure eslint and eslint prettier plugin don't collide
      -- https://www.lazyvim.org/configuration/recipes#add-eslint-and-use-it-for-formatting
      servers = {
        tailwindcss = {
          filetypes = {
            "templ",
            "vue",
            "html",
            "astro",
            "javascript",
            "typescript",
            "react",
            "htmlangular",
          },
        },
        eslint = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "html",
            "markdown",
            "json",
            "jsonc",
            "yaml",
            "toml",
            "xml",
            "gql",
            "graphql",
            "astro",
            "svelte",
            "css",
            "less",
            "scss",
            "pcss",
            "postcss",
          },
          settings = {
            -- Silent the stylistic rules in your IDE, but still auto fix them
            rulesCustomizations = {
              { rule = "style/*", severity = "off", fixable = true },
              { rule = "format/*", severity = "off", fixable = true },
              { rule = "*-indent", severity = "off", fixable = true },
              { rule = "*-spacing", severity = "off", fixable = true },
              { rule = "*-spaces", severity = "off", fixable = true },
              { rule = "*-order", severity = "off", fixable = true },
              { rule = "*-dangle", severity = "off", fixable = true },
              { rule = "*-newline", severity = "off", fixable = true },
              { rule = "*quotes", severity = "off", fixable = true },
              { rule = "*semi", severity = "off", fixable = true },
            },
          },
        },
        tsserver = {
          root_dir = require("lspconfig").util.root_pattern(".git"),
        },
      },
    },
  },
}
