return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      open_mapping = [[<c-\>]],
    }
  end,
}
