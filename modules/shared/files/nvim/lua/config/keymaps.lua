-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set

-- ESLint fix keymap
map("n", "<leader>ce", "<cmd>EslintFixAll<cr>", { desc = "ESLint Fix All" })
map("n", "<leader>gl", function()
  Snacks.lazygit.log()
end, { desc = "Lazygit (git log)" })
map("n", "<leader>gL", function()
  Snacks.lazygit.log_file()
end, { desc = "Lazygit (git log file)" })

map("n", "<S-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<C-tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })

map("n", "gb", "<cmd>BufferLinePick<cr>", { desc = "Buffer Pick" })
map("n", "gB", "<cmd>BufferLinePickClose<cr>", { desc = "Buffer Pick Close" })
