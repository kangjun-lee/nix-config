-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

local opt = vim.opt
opt.clipboard = ""

opt.scrolloff = 10
opt.smarttab = true
opt.tabstop = 2
opt.wrap = false
opt.backspace = { "start", "eol", "indent" }
opt.path:append({ "**" })
opt.wildignore:append({ "*/node_modules/*" })
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.mouse = ""

vim.g.lazyvim_picker = "fzf"

opt.formatoptions:append({ "r" })

vim.g.lazyvim_prettier_needs_config = false

local function get_project_relative_path()
  local root = LazyVim.root()
  local filepath = vim.fn.expand("%:p")
  if root and filepath:sub(1, #root) == root then
    return filepath:sub(#root + 2)
  end
  return vim.fn.expand("%:~:.")
end

vim.keymap.set("n", "<leader>C", function()
  local relpath = get_project_relative_path()
  local clip = "@" .. relpath
  vim.fn.setreg("+", clip)
  print("Copied: " .. clip)
end, { desc = "Copy relative path with line", noremap = true })

vim.keymap.set("v", "<leader>C", function()
  local relpath = get_project_relative_path()
  local srow = vim.fn.line("v")
  local erow = vim.fn.line(".")
  if srow > erow then
    srow, erow = erow, srow
  end
  local linespec = (srow == erow) and ("#L" .. srow) or ("#L" .. srow .. "-L" .. erow)
  local clip = "@" .. relpath .. linespec
  vim.fn.setreg("+", clip)
  print("Copied: " .. clip)
end, { desc = "Copy relative path with line range", noremap = true })

vim.keymap.set("n", "<leader>Y", function()
  local abs = vim.fn.expand("%:p")
  vim.fn.setreg("+", abs)
  print("Copied: " .. abs)
end, { desc = "Copy absolute file path", noremap = true })

vim.keymap.set("v", "<leader>Y", function()
  local abs = vim.fn.expand("%:p")
  local srow = vim.fn.line("v")
  local erow = vim.fn.line(".")
  if srow > erow then
    srow, erow = erow, srow
  end
  local linespec = (srow == erow) and ("#L" .. srow) or ("#L" .. srow .. "-L" .. erow)
  local clip = abs .. linespec
  vim.fn.setreg("+", clip)
  print("Copied: " .. clip)
end, { desc = "Copy absolute path with line range", noremap = true })

vim.g.lazyvim_prettier_needs_config = true
-- vim.g.lazyvim_eslint_auto_format = true

vim.g.lazyvim_rust_diagnostics = "bacon-ls"

vim.keymap.set("n", "<leader>Tn", "<cmd>TodoTxt new<cr>", { desc = "New todo entry" })
vim.keymap.set("n", "<leader>Tt", "<cmd>TodoTxt<cr>", { desc = "Toggle todo.txt" })
vim.keymap.set("n", "<leader>Td", "<cmd>DoneTxt<cr>", { desc = "Toggle done.txt" })
vim.keymap.set("n", "<leader>Tg", "<cmd>TodoTxt ghost<cr>", { desc = "Toggle ghost text" })
vim.keymap.set("n", "<cr>", "<Plug>(TodoTxtToggleState)", { desc = "Toggle task state" })
vim.keymap.set("n", "<c-c>n", "<Plug>(TodoTxtCyclePriority)", { desc = "Cycle priority" })
vim.keymap.set("n", "<leader>Tm", "<Plug>(TodoTxtMoveDone)", { desc = "Move done tasks" })
vim.keymap.set("n", "<leader>Tss", "<Plug>(TodoTxtSortTasks)", { desc = "Sort tasks (default)" })
vim.keymap.set("n", "<leader>Tsp", "<Plug>(TodoTxtSortByPriority)", { desc = "Sort by priority" })
vim.keymap.set("n", "<leader>Tsc", "<Plug>(TodoTxtSortByContext)", { desc = "Sort by context" })
vim.keymap.set("n", "<leader>TsP", "<Plug>(TodoTxtSortByProject)", { desc = "Sort by project" })
vim.keymap.set("n", "<leader>Tsd", "<Plug>(TodoTxtSortByDueDate)", { desc = "Sort by due date" })
