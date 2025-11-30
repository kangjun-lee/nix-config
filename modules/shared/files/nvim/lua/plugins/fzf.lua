return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local actions = require("fzf-lua").actions

      -- 🔁 update keymapping: remove alt-h, add ctrl-h
      opts.files = opts.files or {}
      opts.files.actions = opts.files.actions or {}
      opts.files.actions["alt-h"] = nil
      opts.files.actions["ctrl-h"] = { actions.toggle_hidden }

      opts.grep = opts.grep or {}
      opts.grep.actions = opts.grep.actions or {}
      opts.grep.actions["alt-h"] = nil
      opts.grep.actions["ctrl-h"] = { actions.toggle_hidden }

      opts.file_ignore_patterns = {
        "node_modules",
        "go/pkg",
        "dist",
        "\\.next",
        "\\.git/",
        "\\.gitlab",
        "build",
        "target",
        "package-lock.json",
        "pnpm-lock.yaml",
        "yarn.lock",
        ".DS_Store",
        "storybook-static",
      }
    end,
  },
}
