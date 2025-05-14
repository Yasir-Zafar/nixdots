return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = {
      'folke/which-key.nvim',
      'mfussenegger/nvim-dap', -- For debugging
    },
    opts = function()
      return {
        -- JDTLS configuration options
        cmd = {
          'jdtls',
          '--jvm-arg=-javaagent:' .. vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar',
          '-data',
          vim.fn.expand '~/.cache/jdtls-workspace' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
        },
        root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
        settings = {
          java = {
            format = {
              enabled = true,
              settings = { url = vim.fn.expand '$HOME/.local/share/nvim/mason/packages/google-java-format/google-java-format.xml' },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
              favoriteStaticMembers = {
                'org.junit.Assert.*',
                'org.junit.Assume.*',
                'org.junit.jupiter.api.Assertions.*',
                'org.junit.jupiter.api.Assumptions.*',
                'org.junit.jupiter.api.DynamicContainer.*',
                'org.junit.jupiter.api.DynamicTest.*',
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
              },
              hashCodeEquals = {
                useJava7Objects = true,
              },
              useBlocks = true,
            },
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-17',
                  path = vim.fn.expand '$JAVA_HOME',
                  default = true,
                },
              },
            },
          },
        },
        init_options = {
          bundles = {
            -- Include Java Debug Server and Test bundles
            vim.fn.glob(vim.fn.expand '$HOME/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true),
            unpack(vim.split(vim.fn.glob(vim.fn.expand '$HOME/.local/share/nvim/mason/packages/java-test/extension/server/*.jar', true), '\n')),
          },
        },
        on_attach = function(client, bufnr)
          -- Set up buffer-local keymaps, etc.
          local wk = require 'which-key'
          wk.register({
            ['<leader>J'] = {
              name = '+Java',
              o = {
                function()
                  require('jdtls').organize_imports()
                end,
                'Organize Imports',
              },
              v = {
                function()
                  require('jdtls').extract_variable()
                end,
                'Extract Variable',
              },
              c = {
                function()
                  require('jdtls').extract_constant()
                end,
                'Extract Constant',
              },
              m = {
                function()
                  require('jdtls').extract_method()
                end,
                'Extract Method',
              },
              t = {
                function()
                  require('jdtls').test_nearest_method()
                end,
                'Test Method',
              },
              T = {
                function()
                  require('jdtls').test_class()
                end,
                'Test Class',
              },
              C = { name = '+Checkstyle', l = { '<cmd>!checkstyle -c /sun_checks.xml %<CR>', 'Lint Current File' } },
              F = { '<cmd>!google-java-format --replace %<CR>', 'Format Current File' },
            },
          }, { buffer = bufnr })

          -- Format on save
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('JdtlsFormat', { clear = true }),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
      }
    end,
    config = function(_, opts)
      -- Setup Java file detection to launch JDTLS
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('JavaLSP', { clear = true }),
        pattern = 'java',
        callback = function()
          require('jdtls').start_or_attach(opts)
        end,
      })
    end,
  },
}
