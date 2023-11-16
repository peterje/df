-- Split window
vim.keymap.set('n', 'ss', ':split<Return>', opts)
vim.keymap.set('n', 'sv', ':vsplit<Return>', opts)
-- Move window
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sl', '<C-w>l')
