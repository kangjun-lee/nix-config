return {
  {

    "phrmendes/todotxt.nvim",
    cmd = { "TodoTxt", "DoneTxt" },
    opts = {
      todotxt = "/Users/gangjun/todo.txt",
      donetxt = "/Users/gangjun/done.txt",
      ghost_text = {
        enable = true,
        mappings = {
          ["(A)"] = "now",
          ["(B)"] = "next",
          ["(C)"] = "today",
        },
      },
    },
  },
}
