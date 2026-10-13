local path = require("util.path")

return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    {
      "<leader>e",
      function()
        require("yazi").yazi(nil, LazyVim.root())
      end,
      desc = "Yazi (Root Dir)",
    },
    {
      "<leader>E",
      function()
        require("yazi").yazi(nil, path.buffer_dir())
      end,
      desc = "Yazi (Current Dir)",
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
