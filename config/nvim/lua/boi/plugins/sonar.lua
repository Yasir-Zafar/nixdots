return {
  {
    'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    event = 'BufReadPre',
    config = function()
      require('sonarlint').setup {
        server = {
          cmd = {
            'sonarlint-language-server',
            '-stdio',
            '-analyzers',
            vim.fn.expand '$MASON/packages/sonarlint-language-server/extension/analyzers/sonarjs.jar',
          },
        },
        filetypes = {
          'javascript',
          'typescript',
          'javascriptreact',
          'typescriptreact',
        },
      }
    end,
  },
}
