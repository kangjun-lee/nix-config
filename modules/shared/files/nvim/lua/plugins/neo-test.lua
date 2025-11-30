local function contains_vitest_import(file_path)
  local f = io.open(file_path, "r")
  if not f then
    return false
  end
  for line in f:lines() do
    if line:find("import%.meta%.vitest") then
      f:close()
      return true
    end
  end
  f:close()
  return false
end

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {
          vitestCommand = "pnpm vitest",

          cwd = function(testFilePath)
            return vim.fs.root(testFilePath, ".git")
          end,

          filter_dir = function(name, rel_path, root)
            local ignore_dirs = { "node_modules", "dist", ".next", ".cursor", ".claude", "build", "out", "target" }
            return not vim.list_contains(ignore_dirs, name)
          end,

          vitestConfigFile = function(path)
            return "empty_for_automatically_find_config"
          end,
        },
      },
    },
  },
}
