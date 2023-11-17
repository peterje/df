vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.expandtab = true
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.cmd [[set cmdheight=0]]
vim.cmd [[set number]]
vim.cmd [[set relativenumber]]
vim.keymap.set('n', '<leader>sd', ':w<CR>:bd<CR>', { silent = true, noremap = true })
require 'peteredm.core'
require 'peteredm.lazy'
