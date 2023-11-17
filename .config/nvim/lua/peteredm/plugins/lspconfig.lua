local servers = {
  gopls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'j-hui/fidget.nvim', opts = {} },
    'folke/neodev.nvim',
  },
  config = function()
    require('mason').setup()
    -- Setup neovim lua configuration
    require('neodev').setup()
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'

    local keymap = vim.keymap -- for conciseness
    local opts = { noremap = true, silent = true }
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr
    end
    -- set keybinds
    opts.desc = 'Show LSP references'
    keymap.set('n', 'gR', '<cmd>Telescope lsp_references<CR>', opts) -- show definition, references

    opts.desc = 'Go to declaration'
    keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- go to declaration

    opts.desc = 'Show LSP definitions'
    keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts) -- show lsp definitions

    opts.desc = 'Show LSP implementations'
    keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts) -- show lsp implementations

    opts.desc = 'Show LSP type definitions'
    keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts) -- show lsp type definitions

    opts.desc = 'See available code actions'
    keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = 'Smart rename'
    keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = 'Show buffer diagnostics'
    keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', opts) -- show  diagnostics for file

    opts.desc = 'Show line diagnostics'
    keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts) -- show diagnostics for line

    opts.desc = 'Go to previous diagnostic'
    keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

    opts.desc = 'Go to next diagnostic'
    keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

    opts.desc = 'Show documentation for what is under cursor'
    keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = 'Restart LSP'
    keymap.set('n', '<leader>rs', ':LspRestart<CR>', opts) -- mapping to restart lsp if necessary

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    local nvim_lsp = require 'lspconfig'
    -- Custom root directory function
    local function project_root_dir(fname)
      local util = nvim_lsp.util
      local root_files = {
        'deno.json', -- Deno project
        'deno.jsonc', -- Deno project (JSON with comments)
        'import_map.json', -- Deno project
        'package.json', -- Node.js project
      }

      local root = util.root_pattern(unpack(root_files))(fname)

      if
        root
        and (
          util.path.exists(util.path.join(root, 'deno.json'))
          or util.path.exists(util.path.join(root, 'deno.jsonc'))
          or util.path.exists(util.path.join(root, 'import_map.json'))
        )
      then
        return root, 'denols'
      elseif root and util.path.exists(util.path.join(root, 'package.json')) then
        return root, 'tsserver'
      end

      return nil
    end

    mason_lspconfig.setup_handlers {
      function(server_name)
        if server_name == 'tsserver' or server_name == 'denols' then
          local lsp_setup = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
            root_dir = function(fname)
              local root, lsp_type = project_root_dir(fname)
              if server_name == lsp_type then
                return root
              end
            end,
          }
          if server_name == 'tsserver' then
            lsp_setup.single_file_support = false
          end
          require('lspconfig')[server_name].setup(lsp_setup)
        else
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end
      end,
    }
  end,
}
