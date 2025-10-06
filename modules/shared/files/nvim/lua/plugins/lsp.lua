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
        eslint = {
          -- Simplify root_patterns as it changes root_dir in monorepos with default config
          root_dir = require("lspconfig").util.root_pattern(".git"),
          -- @antfu/eslint-config customizations
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
            -- Silent the stylistic rules in you IDE, but still auto fix them
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
        tailwindcss = {
          -- Simplify root_patterns as it changes root_dir in monorepos with default config
          root_dir = require("lspconfig").util.root_pattern(
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            -- Or, just fallback to `.git`
            ".git"
          ),
        },
        tsserver = {
          root_dir = require("lspconfig").util.root_pattern(".git"),
        },
      },
      -- The below may no longer be needed now that LazyVim has been updated to v10
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client, bufnr)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
              -- Format on save with EslintFixAll
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
}
