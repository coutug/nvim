return {  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  "folke/tokyonight.nvim",
  priority = 1000,
  init = function()
    vim.cmd.colorscheme("lunaperche")
    vim.cmd.hi("Comment gui=none")
  end,
}
