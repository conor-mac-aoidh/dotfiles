return  {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/nvim-lsp-installer',
    'jose-elias-alvarez/null-ls.nvim',
  },
  config = function()
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities() 
    local util = require 'lspconfig.util'

    lspconfig.ts_ls.setup {
      capabilities = capabilities,
      -- root_dir = util.root_pattern('tsconfig.editor.json', 'tsconfig.app.json', 'tsconfig.json', 'project.json', '.git'),
      root_dir = util.root_pattern('.git'),
    }

    lspconfig.nxls.setup{}

    local lsp_installer = require("nvim-lsp-installer")
    lsp_installer.setup {
      ensure_installed = { "ts_ls", "eslint", "null-ls" },
    }

    -- Update Neovim's path for NX monorepo
    vim.opt.path:append({ 'apps/**', 'libs/**', 'node_modules', '.' })

    vim.api.nvim_create_user_command('ToggleInlayHints', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, {})

    -- peak into file
    vim.api.nvim_set_keymap('n', 'gp', '<cmd>Lspsaga peek_definition<CR>', { noremap = true, silent = true })
    -- show diagnostics
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
  end,
}
