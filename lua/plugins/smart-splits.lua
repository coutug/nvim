return {
  "smart-splits-nvim/smart-splits.nvim",
  version = "^3.0.0",
  -- optional: install a backend
  dependencies = {
    {
      "smart-splits-nvim/backend-wezterm",
      commit = "ae840db696791f638c190c3e0534d2ddfcd5e6a7",
      main = "smart-splits-backend-wezterm",
      opts = {
        cli_path = "wezterm",
      },
    },
  },
  opts = {
    move = { at_edge = "stop" },
    mux = { backend = "smart-splits-backend-wezterm" },
  },
  keys = {
    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      mode = { "n", "t" },
      desc = "Move left across Neovim windows and WezTerm panes",
    },
    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      mode = { "n", "t" },
      desc = "Move down across Neovim windows and WezTerm panes",
    },
    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      mode = { "n", "t" },
      desc = "Move up across Neovim windows and WezTerm panes",
    },
    {
      "<C-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      mode = { "n", "t" },
      desc = "Move right across Neovim windows and WezTerm panes",
    },
  },
}
