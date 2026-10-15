-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del({ "n", "t" }, "<c-/>")
vim.keymap.del({ "n", "t" }, "<c-_>")

if vim.fn.executable("lazygit") == 1 then
  vim.keymap.del("n", "<leader>gg")
  vim.keymap.del("n", "<leader>gG")
end

vim.keymap.set("n", "<leader>ze", function()
  require("util.sops").edit_current_file()
end, { desc = "SOPS Encrypt and Edit" })
