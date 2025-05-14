return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      on_attach = function(client, bufnr)
        -- Integrate with LSP
        local wk = require 'which-key'
        wk.register({
          ['<leader>T'] = {
            name = '+TypeScript',
            o = { '<cmd>TSToolsOrganizeImports<CR>', 'Organize Imports' },
            R = { '<cmd>TSToolsRenameFile<CR>', 'Rename File' },
            i = { '<cmd>TSToolsAddMissingImports<CR>', 'Add Missing Imports' },
            F = { '<cmd>TSToolsFixAll<CR>', 'Fix All' },
            u = { '<cmd>TSToolsRemoveUnused<CR>', 'Remove Unused' },
            s = { '<cmd>TSToolsSortImports<CR>', 'Sort Imports' },
          },
        }, { buffer = bufnr })
      end,
    },
  },
}
