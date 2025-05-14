return {
  {
    'nvimtools/none-ls.nvim',
    config = function()
      require('null-ls').setup()

      local null_ls = require 'null-ls'

      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.statix.with {
            command = 'statix', -- make sure this resolves correctly
            filetypes = { 'nix' },
          },
        },
      }
    end,
  },

  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.nix',
    callback = function()
      vim.lsp.buf.format { async = false }
    end,
  }),
}
