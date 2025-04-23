vim.api.nvim_create_autocmd('TermOpen', {
	group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

vim.keymap.set('n', '<leader>t', function()
  vim.cmd('split | terminal')  -- Ouvre un terminal dans une split horizontale
  vim.cmd('startinsert')       -- Passe automatiquement en mode insert
end, { desc = "Open terminal in insert mode" })

