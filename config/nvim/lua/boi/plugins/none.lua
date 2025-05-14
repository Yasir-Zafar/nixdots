return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        lua = { 'luacheck' },
        java = { 'checkstyle' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        nix = { 'statix' },
        c = { 'clangtidy' },
        cpp = { 'clangtidy' },
      }

      -- Run lint on save
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
