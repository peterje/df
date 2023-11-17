return {
  'ThePrimeagen/git-worktree.nvim',
  config = function()
    require('git-worktree').setup {}
  end,
  keys = {
    {
      'gw',
      function()
        require('telescope').extensions.git_worktree.git_worktrees()
      end,
      desc = 'git worktrees',
    },
    {
      'gwc',
      function()
        require('telescope').extensions.git_worktree.create_git_worktree()
      end,
      desc = 'git worktrees',
    },
  },
}
