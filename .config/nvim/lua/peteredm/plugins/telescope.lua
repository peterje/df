return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-telescope/telescope-file-browser.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    config = function()
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'
      local fb_actions = require('telescope').extensions.file_browser.actions
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          diagnostics = {
            theme = 'ivy',
            initial_mode = 'normal',
            layout_config = {
              preview_cutoff = 9999,
            },
          },
        },
        extensions = {
          file_browser = {
            theme = 'dropdown',
            hijack_netrw = true,
            mappings = {
              ['n'] = {
                ['l'] = fb_actions.change_cwd,
                ['h'] = fb_actions.goto_parent_dir,
                ['.'] = fb_actions.toggle_hidden,
                ['c'] = fb_actions.create,
                ['d'] = fb_actions.remove,
                ['r'] = fb_actions.rename,
                ['H'] = fb_actions.goto_home_dir,
                ['/'] = function()
                  vim.cmd 'startinsert'
                end,
                ['<C-u>'] = function(prompt_bufnr)
                  for i = 1, 10 do
                    actions.move_selection_previous(prompt_bufnr)
                  end
                end,
                ['<C-d>'] = function(prompt_bufnr)
                  for i = 1, 10 do
                    actions.move_selection_next(prompt_bufnr)
                  end
                end,
                ['<PageUp>'] = actions.preview_scrolling_up,
                ['<PageDown>'] = actions.preview_scrolling_down,
              },
            },
          },
        },
      }
      telescope.load_extension 'fzf'
      telescope.load_extension 'git_worktree'
      telescope.load_extension 'file_browser'
    end,
    keys = {
      {
        ';d',
        function()
          local function telescope_buffer_dir()
            return vim.fn.expand '%:p:h'
          end
          require('telescope').extensions.file_browser.file_browser {
            path = '%:p:h',
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = 'normal',
            layout_config = { height = 40 },
          }
        end,
        desc = 'filesearch (directory)',
      },
      {
        ';s',
        function()
          local builtin = require 'telescope.builtin'
          builtin.live_grep()
        end,
        desc = 'filesearch (string)',
      },
      {
        ';b',
        function()
          local builtin = require 'telescope.builtin'
          builtin.buffers()
        end,
        desc = 'filesearch (buffers)',
      },
      {
        ';f',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'filesearch (fuzzy)',
      },
      { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'commits' },
      { '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'status' },
    },
  },
}
