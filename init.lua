vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4

-- Windows
opt.splitright = true
opt.splitbelow = true

-- Persistence
opt.undofile = true

-- UI responsiveness
opt.updatetime = 250
opt.timeoutlen = 300

-- True colors
opt.termguicolors = true

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Easier window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- System clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
