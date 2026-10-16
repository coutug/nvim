return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = {
    "MarkdownPreview",
    "MarkdownPreviewStop",
    "MarkdownPreviewToggle",
  },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>mp",
      "<cmd>MarkdownPreviewToggle<cr>",
      ft = "markdown",
      desc = "Markdown Preview",
    },
  },
}
