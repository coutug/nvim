return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,

    opts = {
      options = {
        transparent = true,
      },
    },

    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd.colorscheme("github_dark")
    end,
  },
}
