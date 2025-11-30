return {
  {
    "coder/claudecode.nvim",
    enabled = false,
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {},
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "frankroeder/parrot.nvim",
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("parrot").setup({
        providers = {
          anthropic = {
            name = "anthropic",
            api_key = os.getenv("ANTHROPIC_API_KEY"),
            endpoint = "https://api.anthropic.com/v1/messages",
            topic_prompt = "https://api.anthropic.com/v1/models",
            topic = {
              model = "claude-sonnet-4-5-20250929",
              params = { max_tokens = 4096 },
            },
            params = {
              chat = { max_tokens = 4096 },
              command = { max_tokens = 4096 },
            },
            models = {
              "claude-sonnet-4-5-20250929",
              "claude-haiku-4-5-20251001",
            },
            headers = function(self)
              return {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = self.api_key,
                ["anthropic-version"] = "2023-06-01",
              }
            end,
            preprocess_payload = function(payload)
              for _, message in ipairs(payload.messages) do
                message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
              end
              if payload.messages[1] and payload.messages[1].role == "system" then
                -- remove the first message that serves as the system prompt as anthropic
                -- expects the system prompt to be part of the API call body and not the messages
                payload.system = payload.messages[1].content
                table.remove(payload.messages, 1)
              end
              return payload
            end,
          },
        },
        hooks = {
          Complete = function(prt, params)
            local template = [[
              I have the following code from {{filename}}:

              ```{{filetype}}
              {{filecontent}}
              ```

              Please look at the following section specifically:
              ```{{filetype}}
              {{selection}}
              ```

              Please finish the code above carefully and logically.
              Respond just with the snippet of code that should be inserted.
            ]]
            local model_obj = prt.get_model("command")
            prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
          end,
          Explain = function(prt, params)
            local template = [[
              Your task is to take the code snippet from {{filename}} and explain it.
              Break down the code's functionality, purpose, and key components.

              ```{{filetype}}
              {{selection}}
              ```

              Use the markdown format with codeblocks.
            ]]
            prt.Prompt(
              params,
              prt.Target.new_buf,
              nil,
              prt.config.chat_model,
              template,
              nil,
              prt.config.chat_system_prompt
            )
          end,
          FixBugs = function(prt, params)
            local template = [[
              You are an expert in {{filetype}}.
              Fix bugs in the below code from {{filename}} carefully and logically:

              ```{{filetype}}
              {{selection}}
              ```

              Respond with the complete fixed code.
            ]]
            local model_obj = prt.get_model("command")
            prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
          end,
          Optimize = function(prt, params)
            local template = [[
              You are an expert in {{filetype}}.
              Optimize the following code from {{filename}}:

              ```{{filetype}}
              {{selection}}
              ```

              Respond with the optimized code.
            ]]
            local model_obj = prt.get_model("command")
            prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
          end,
        },
      })
    end,
    keys = {
      -- Chat commands
      { "<leader>ac", "<cmd>PrtChatNew<cr>", desc = "New AI Chat", mode = { "n", "v" } },
      { "<leader>at", "<cmd>PrtChatToggle<cr>", desc = "Toggle AI Chat", mode = { "n", "v" } },
      { "<leader>af", "<cmd>PrtChatFinder<cr>", desc = "Find AI Chat", mode = { "n", "v" } },
      { "<leader>ad", "<cmd>PrtChatDelete<cr>", desc = "Delete AI Chat", mode = { "n", "v" } },
      { "<leader>as", "<cmd>PrtStop<cr>", desc = "Stop AI Response", mode = { "n", "v" } },
      -- leader a enter to trigger PrtChatRespond

      -- Code editing commands
      { "<leader>ar", "<cmd>PrtRewrite<cr>", desc = "AI Rewrite", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>PrtAppend<cr>", desc = "AI Append", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>PrtPrepend<cr>", desc = "AI Prepend", mode = { "n", "v" } },
      { "<leader>ae", "<cmd>PrtEdit<cr>", desc = "AI Edit", mode = { "n", "v" } },
      { "<leader>ax", "<cmd>PrtContext<cr>", desc = "AI Context Menu", mode = { "n", "v" } },

      -- Hook-based commands
      { "<leader>aR", "<cmd>PrtRetry<cr>", desc = "AI Retry", mode = { "n", "v" } },
      { "<leader>aC", ":PrtComplete<cr>", desc = "AI Complete Code", mode = { "n", "v" } },
      { "<leader>aE", ":PrtExplain<cr>", desc = "AI Explain Code", mode = { "n", "v" } },
      { "<leader>aF", ":PrtFixBugs<cr>", desc = "AI Fix Bugs", mode = { "n", "v" } },
      { "<leader>aO", ":PrtOptimize<cr>", desc = "AI Optimize Code", mode = { "n", "v" } },

      -- Provider selection
      { "<leader>am", "<cmd>PrtModel<cr>", desc = "Select AI Model", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>PrtInfo<cr>", desc = "AI Info", mode = { "n", "v" } },
    },
  },
}
