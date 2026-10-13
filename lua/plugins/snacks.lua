local path = require("util.path")

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
    { "<leader>e", false },
    { "<leader>E", false },
    {
      "<leader>t",
      function()
        Snacks.terminal.toggle(nil, {
          cwd = LazyVim.root(),
        })
      end,
      desc = "Terminal (Root Dir)",
    },
    {
      "<leader>T",
      function()
        Snacks.terminal.toggle(nil, {
          cwd = path.buffer_dir(),
        })
      end,
      desc = "Terminal (Current Dir)",
    },
    {
      "<leader>lg",
      function()
        Snacks.lazygit({
          cwd = LazyVim.root.git(),
        })
      end,
      desc = "Lazygit (Root Dir)",
    },
    {
      "<leader>h",
      function()
        Snacks.terminal.toggle({ "htop" }, {
          cwd = LazyVim.root(),
        })
      end,
      desc = "Htop",
    },
    {
      "<leader>oc",
      function()
        Snacks.terminal.toggle({ "opencode" }, {
          cwd = LazyVim.root(),
        })
      end,
      desc = "OpenCode (Root Dir)",
    },
    {
      "<leader>OC",
      function()
        Snacks.terminal.toggle({ "opencode" }, {
          cwd = path.buffer_dir(LazyVim.root()),
        })
      end,
      desc = "OpenCode (Current Dir)",
    },
  },
}
