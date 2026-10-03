return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        position = "float",
        border = "rounded",
        width = 0.9,
        height = 0.9,
      },
    },
  },
  keys = {
    -- new keymaps
    {
      "<leader>tt",
      function()
        Snacks.terminal.toggle(nil, {
          cwd = LazyVim.root(),
        })
      end,
      desc = "Terminal (Root Dir)",
    },
    {
      "<leader>tg",
      function()
        Snacks.lazygit({
          cwd = LazyVim.root.git(),
        })
      end,
      desc = "Lazygit (Root Dir)",
    },
    {
      "<leader>th",
      function()
        Snacks.terminal.toggle("htop", {
          cwd = LazyVim.root(),
        })
      end,
      desc = "Htop",
    },
  },
}
