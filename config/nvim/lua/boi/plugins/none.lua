return {
  {
    'nvimtools/none-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local null_ls = require 'null-ls'

      null_ls.setup {
        sources = {
          -- Nix
          null_ls.builtins.diagnostics.statix.with {
            command = '/run/current-system/sw/bin/statix',
            filetypes = { 'nix' },
          },

          -- Lua
          -- null_ls.builtins.diagnostics.luacheck.with {
          --   command = '/run/current-system/sw/bin/luacheck',
          --   filetypes = { 'lua' },
          -- },

          -- Java (Checkstyle)
          null_ls.builtins.diagnostics.checkstyle.with {
            command = '/run/current-system/sw/bin/checkstyle',
            -- args = { '-c', '.google_checks.xml', '-' }, -- adjust config path
            filetypes = { 'java' },
          },

          -- JavaScript/TypeScript
          null_ls.builtins.diagnostics.eslint_d.with {
            command = '/run/current-system/sw/bin/eslint', -- or 'eslint' if you prefer
            filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          },

          -- C (Clang-Tidy)
          null_ls.builtins.diagnostics.clang_check.with {
            command = 'clang-tidy',
            filetypes = { 'c', 'cpp', 'h', 'cc' },
            args = { '--quiet', '-' },
          },
        },
      }

      -- Autoformat on save (only if formatting is configured)
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.nix', '*.lua', '*.java', '*.js', '*.ts', '*.c', '*.cpp' },
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end,
  },
}
