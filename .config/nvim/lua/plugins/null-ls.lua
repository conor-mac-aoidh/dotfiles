return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/nvim-lsp-installer',
    'jose-elias-alvarez/null-ls.nvim',
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- null_ls.builtins.formatting.prettier.with({ filetypes = { "html", "css", "javascript", "typescript" } }),

        null_ls.builtins.diagnostics.eslint,
      },
    })
  end
}
