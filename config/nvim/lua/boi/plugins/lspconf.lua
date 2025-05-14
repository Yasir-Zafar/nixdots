return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
      'williamboman/mason.nvim',
      'nvim-lua/plenary.nvim', -- For some formatters/linters

      -- Optional but recommended LSP enhancements
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }, -- Recognize 'vim' global in Neovim config
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- Nix
      lspconfig.nil_ls.setup {}

      -- Java
      lspconfig.jdtls.setup {
        -- Java-specific settings
        settings = {
          java = {
            format = {
              settings = {
                url = vim.fn.stdpath 'config' .. '/lang-servers/java-format-settings.xml',
              },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
          },
        },
      }

      -- TypeScript/JavaScript
      lspconfig.ts_ls.setup = {
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = '/usr/local/lib/node_modules/@vue/typescript-plugin',
              languages = { 'javascript', 'typescript', 'vue' },
            },
          },
        },
        filetypes = {
          'javascript',
          'typescript',
          'vue',
        },
      }
      -- ESLint
      lspconfig.eslint.setup = {
        settings = {
          workingDirectories = { { mode = 'auto' } },
        },
      }
      -- CSS
      lspconfig.cssls.setup = {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = 'ignore',
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = 'ignore',
            },
          },
        },
      }
      -- HTML
      lspconfig.html.setup = {
        filetypes = { 'html', 'javascriptreact', 'typescriptreact' },
      }
      -- JSON
      lspconfig.jsonls.setup = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }

      lspconfig.clangd.setup {
        -- Basic setup with default options
        -- If needed, you can add specific configurations:
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders',
          '--fallback-style=llvm',
        },
        init_options = {
          compilationDatabasePath = 'build', -- If you have compile_commands.json in a build directory
          -- fallbackFlags = {
          --   '-std=c++17',
          --   '-I/nix/store/1qq2wmiqckvjiiwrp3nq4kw2dlnngmla-libcxx-19.1.7/include/c++/v1',
          --   '-I/nix/store/f16xdvddql4q386incjvxcys4g4dcavj-clang-wrapper-19.1.7/resource/include',
          -- },
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
      }
      lspconfig.setup = {
        eslint = function()
          -- Automatically fix eslint issues on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
            callback = function(event)
              if require('lspconfig.util').get_active_client_by_name(event.buf, 'eslint') then
                vim.cmd 'EslintFixAll'
              end
            end,
          })
          return true
        end,
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
    end,
  },
}
