return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  config = function()
    require("markview").setup({
      preview = {
        enable = true,
        enable_hybrid_mode = true,
        filetypes = { "markdown" },
        icon_provider = "internal",
      },
    })
  end,
  keys = {
    {
      "<leader>mp",
      "<cmd>Markview toggle<cr>",
      ft = "markdown",
      desc = "Toggle Markdown Preview",
    },
    {
      "<leader>ms",
      "<cmd>Markview splitToggle<cr>",
      ft = "markdown",
      desc = "Toggle Markdown Split Preview",
    },
    {
      "<leader>mh",
      "<cmd>Markview hybridToggle<cr>",
      ft = "markdown",
      desc = "Toggle Markdown Hybrid Mode",
    },
  },
}
