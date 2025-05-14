{pkgs, ...}: {
  programs.nixvim = {
    # Dependencies
    # { 'Bilal2453/luvit-meta', lazy = true },
    #
    #
    # Allows extra capabilities providied by nvim-cmp
    # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
    plugins.cmp-nvim-lsp = {
      enable = true;
    };

    # Useful status updates for LSP.
    # https://nix-community.github.io/nixvim/plugins/fidget/index.html
    plugins.fidget = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugi#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # NOTE: This is where you would add a vim plugin that is not implemented in Nixvim, also see extraConfigLuaPre below
      plenary-nvim # Added for some formatters/linters
      # TODO: Add luvit-meta when Nixos package is added
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      "kickstart-lsp-attach" = {
        clear = true;
      };
      "kickstart-lsp-detach" = {
        clear = true;
      };
      "kickstart-lsp-highlight" = {
        clear = false;
      };
    };

    # Brief aside: **What is LSP?**
    #
    # LSP is an initialism you've probably heard, but might not understand what it is.
    #
    # LSP stands for Language Server Protocol. It's a protocol that helps editors
    # and language tooling communicate in a standardized fashion.
    #
    # In general, you have a "server" which is some tool built to understand a particular
    # language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    # (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    # processes that communicate with some "client" - in this case, Neovim!
    #
    # LSP provides Neovim with features like:
    #  - Go to definition
    #  - Find references
    #  - Autocompletion
    #  - Symbol Search
    #  - and more!
    #
    # Thus, Language Servers are external tools that must be installed separately from
    # Neovim which are configured below in the `server` section.
    #
    # If you're wondering about lsp vs treesitter, you can check out the wonderfully
    # and elegantly composed help section, `:help lsp-vs-treesitter`
    #
    # https://nix-community.github.io/nixvim/plugins/lsp/index.html
    plugins.lsp = {
      enable = true;

      # Added from paste-2.txt
      capabilities = ''
        capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      '';

      # Enable the following language servers
      #  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      #
      #  Add any additional override configuration in the following tables. Available keys are:
      #  - cmd: Override the default command used to start the server
      #  - filetypes: Override the default list of associated filetypes for the server
      #  - capabilities: Override fields in capabilities. Can be used to disable certain LSP features.
      #  - settings: Override the default settings passed when initializing the server.
      #        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      servers = {
        # Added from paste-2.txt
        clangd = {
          enable = true;
          cmd = [
            "clangd"
            "--background-index"
            "--clang-tidy"
            "--header-insertion=iwyu"
            "--completion-style=detailed"
            "--function-arg-placeholders"
            "--fallback-style=llvm"
          ];
          
          initOptions = {
            compilationDatabasePath = "build"; # If you have compile_commands.json in a build directory
          };
          
          filetypes = [ "c" "cpp" "objc" "objcpp" ];
        };
        
        gopls = {
          enable = true;
        };
        
        pyright = {
          enable = true;
        };
        
        rust_analyzer = {
          enable = true;
        };
        
        nil_ls = {
          enable = true;
        };
        
        jdtls = {
          enable = true;
          settings = {
            java = {
              format = {
                settings = {
                  url = "vim.fn.stdpath('config') .. '/lang-servers/java-format-settings.xml'";
                };
              };
              signatureHelp = { enabled = true; };
              contentProvider = { preferred = "fernflower"; };
            };
          };
        };
        
        # For TypeScript/JavaScript
        ts_ls = {
          enable = true;
          filetypes = [ "javascript" "typescript" "vue" ];
        };
        
        eslint = {
          enable = true;
          settings = {
            workingDirectories = [ { mode = "auto"; } ];
          };
        };
        
        cssls = {
          enable = true;
          settings = {
            css = {
              validate = true;
              lint = {
                unknownAtRules = "ignore";
              };
            };
            scss = {
              validate = true;
              lint = {
                unknownAtRules = "ignore";
              };
            };
          };
        };
        
        html = {
          enable = true;
          filetypes = [ "html" "javascriptreact" "typescriptreact" ];
        };
        
        jsonls = {
          enable = true;
          settings = {
            json = {
              validate = { enable = true; };
            };
          };
        };

        lua_ls = {
          enable = true;
          
          settings = {
            Lua = {
              diagnostics = {
                globals = [ "vim" ]; # Recognize 'vim' global in Neovim config
              };
              workspace = {
                # Make the server aware of Neovim runtime files
                library = "vim.api.nvim_get_runtime_file('', true)";
                checkThirdParty = false;
              };
              telemetry = {
                enable = false;
              };
              completion = {
                callSnippet = "Replace";
              };
              # diagnostics = {
              #   disable = [
              #     "missing-fields"
              #   ];
              # };
            };
          };
        };
      };
      
      # Added from paste-2.txt for ESLint auto-fixing
      extraConfig = ''
        -- Automatically fix eslint issues on save
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
          callback = function(event)
            if require('lspconfig.util').get_active_client_by_name(event.buf, 'eslint') then
              vim.cmd 'EslintFixAll'
            end
          end,
        })
      '';

      keymaps = {
        # Diagnostic keymaps
        diagnostic = {
          "<leader>q" = {
            mode = "n";
            action = "setloclist";
            desc = "Open diagnostic [Q]uickfix list";
          };
        };

        extra = [
          # Jump to the definition of the word under your cusor.
          #  This is where a variable was first declared, or where a function is defined, etc.
          #  To jump back, press <C-t>.
          {
            mode = "n";
            key = "gd";
            action.__raw = "require('telescope.builtin').lsp_definitions";
            options = {
              desc = "LSP: [G]oto [D]efinition";
            };
          }
          # Find references for the word under your cursor.
          {
            mode = "n";
            key = "gr";
            action.__raw = "require('telescope.builtin').lsp_references";
            options = {
              desc = "LSP: [G]oto [R]eferences";
            };
          }
          # Jump to the implementation of the word under your cursor.
          #  Useful when your language has ways of declaring types without an actual implementation.
          {
            mode = "n";
            key = "gI";
            action.__raw = "require('telescope.builtin').lsp_implementations";
            options = {
              desc = "LSP: [G]oto [I]mplementation";
            };
          }
          # Jump to the type of the word under your cursor.
          #  Useful when you're not sure what type a variable is and you want to see
          #  the definition of its *type*, not where it was *defined*.
          {
            mode = "n";
            key = "<leader>D";
            action.__raw = "require('telescope.builtin').lsp_type_definitions";
            options = {
              desc = "LSP: Type [D]efinition";
            };
          }
          # Fuzzy find all the symbols in your current document.
          #  Symbols are things like variables, functions, types, etc.
          {
            mode = "n";
            key = "<leader>ds";
            action.__raw = "require('telescope.builtin').lsp_document_symbols";
            options = {
              desc = "LSP: [D]ocument [S]ymbols";
            };
          }
          # Fuzzy find all the symbols in your current workspace.
          #  Similar to document symbols, except searches over your entire project.
          {
            mode = "n";
            key = "<leader>ws";
            action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
            options = {
              desc = "LSP: [W]orkspace [S]ymbols";
            };
          }
        ];

        lspBuf = {
          # Rename the variable under your cursor.
          #  Most Language Servers support renaming across files, etc.
          "<leader>rn" = {
            action = "rename";
            desc = "LSP: [R]e[n]ame";
          };
          # Execute a code action, usually your cursor needs to be on top of an error
          # or a suggestion from your LSP for this to activate.
          "<leader>ca" = {
            mode = ["n" "x"];
            action = "code_action";
            desc = "LSP: [C]ode [A]ction";
          };
          # WARN: This is not Goto Definition, this is Goto Declaration.
          #  For example, in C this would take you to the header.
          "gD" = {
            action = "declaration";
            desc = "LSP: [G]oto [D]eclaration";
          };
        };
      };

      # LSP servers and clients are able to communicate to each other what features they support.
      #  By default, Neovim doesn't support everything that is in the LSP specification.
      #  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      #  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      # NOTE: This is done automatically by Nixvim when enabling cmp-nvim-lsp below is an example if you did want to add new capabilities
      #capabilities = ''
      #  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      #'';

      # This function gets run when an LSP attaches to a particular buffer.
      #   That is to say, every time a new file is opened that is associated with
      #   an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      #   function will be executred to configure the current buffer
      # NOTE: This is an example of an attribute that takes raw lua
      onAttach = ''
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- The following two autocommands are used to highlight references of the
        -- word under the cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
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

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      '';
    };
    
    # Added from paste-2.txt for Mason integration
    extraConfigLua = ''
      -- Ensure the servers and tools are installed
      local ensure_installed = {
        "clangd",
        "gopls",
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "nil_ls",
        "jdtls",
        "tsserver",
        "eslint",
        "cssls",
        "html",
        "jsonls",
        "stylua", -- Used to format Lua code
      }

      -- Configure Mason if it's available
      local mason_ok, mason = pcall(require, "mason")
      if mason_ok then
        mason.setup()
        
        -- Check if mason-lspconfig is available
        local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
        if mason_lsp_ok then
          mason_lsp.setup({
            ensure_installed = ensure_installed,
            automatic_installation = true,
          })
        end
      end
    '';
  };
}
