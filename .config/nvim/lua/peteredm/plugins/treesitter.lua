return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'lua', 'markdown', 'markdown_inline' },
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
