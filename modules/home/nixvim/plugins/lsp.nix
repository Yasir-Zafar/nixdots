# Language servers through nixvim's `lsp` module (Neovim's own vim.lsp.config / vim.lsp.enable).
# Was `plugins.lsp` (the nvim-lspconfig wrapper), which nixvim is retiring; nvim-lspconfig is still
# loaded for its per-server defaults (cmd, filetypes, root markers).
{pkgs, ...}: {
  programs.nixvim = {
    plugins.cmp-nvim-lsp.enable = true;

    plugins.fidget = {
      enable = true;
      settings.notification.window.winblend = 0;
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugi#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim # Added for some formatters/linters
    ];

    plugins.lspconfig.enable = true;

    lsp = {
      servers = {
        # every server advertises what nvim-cmp can do (snippets, auto-import, …)
        "*".config.capabilities.__raw = "require('cmp_nvim_lsp').default_capabilities()";

        rust_analyzer = {
          enable = true;
          cargo.enable = true; # cargo + rustc on nvim's PATH for rust-analyzer
          rustc.enable = true;
          config.settings.rust-analyzer = {
            check.command = "clippy"; # use clippy instead of check on save
            cargo.allFeatures = true;
            inlayHints = {
              bindingModeHints.enable = true;
              closureReturnTypeHints.enable = "with_block";
            };
          };
        };

        # C/C++ (clang-tools from nixpkgs; matches nix/development/c.nix)
        clangd = {
          enable = true;
          config = {
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--header-insertion=iwyu"
              "--completion-style=detailed"
              "--function-arg-placeholders"
              "--fallback-style=llvm"
            ];
            filetypes = ["c" "cpp" "objc" "objcpp"];
          };
        };

        nil_ls.enable = true;

        # Python
        basedpyright.enable = true;

        # TypeScript/JavaScript (for vue: add "vue" here, the vue plugin below, and enable vue_ls)
        ts_ls = {
          enable = true;
          config.filetypes = ["typescript" "javascript" "javascriptreact" "typescriptreact"];
          # config.init_options.plugins = [
          #   {
          #     name = "@vue/typescript-plugin";
          #     location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
          #     languages = ["vue"];
          #   }
          # ];
        };
        # vue_ls.enable = true;
        # eslint = {
        #   enable = true;
        #   config.settings.workingDirectories = [{mode = "auto";}];
        # };
        # cssls = {
        #   enable = true;
        #   config.settings = {
        #     css = { validate = true; lint.unknownAtRules = "ignore"; };
        #     scss = { validate = true; lint.unknownAtRules = "ignore"; };
        #   };
        # };
        # html = {
        #   enable = true;
        #   config.filetypes = ["html" "javascriptreact" "typescriptreact"];
        # };

        bashls.enable = true;
        jsonls.enable = true;

        lua_ls = {
          enable = true;
          config.settings.Lua = {
            diagnostics.globals = ["vim"]; # Recognize 'vim' global in Neovim config
            workspace = {
              # Make the server aware of Neovim runtime files
              library.__raw = "vim.api.nvim_get_runtime_file('', true)";
              checkThirdParty = false;
            };
            telemetry.enable = false;
            completion.callSnippet = "Replace";
          };
        };
      };

      # set on the buffer when a server attaches
      keymaps = [
        {
          key = "<leader>q";
          action.__raw = "vim.diagnostic.setloclist";
          options.desc = "Open diagnostic [Q]uickfix list";
        }
        # telescope pickers; jump back with <C-t>
        {
          key = "gd";
          action.__raw = "require('telescope.builtin').lsp_definitions";
          options.desc = "LSP: [G]oto [D]efinition";
        }
        {
          key = "gr";
          action.__raw = "require('telescope.builtin').lsp_references";
          options.desc = "LSP: [G]oto [R]eferences";
        }
        {
          key = "gI";
          action.__raw = "require('telescope.builtin').lsp_implementations";
          options.desc = "LSP: [G]oto [I]mplementation";
        }
        {
          key = "<leader>D";
          action.__raw = "require('telescope.builtin').lsp_type_definitions";
          options.desc = "LSP: Type [D]efinition";
        }
        {
          key = "<leader>ds";
          action.__raw = "require('telescope.builtin').lsp_document_symbols";
          options.desc = "LSP: [D]ocument [S]ymbols";
        }
        {
          key = "<leader>ws";
          action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
          options.desc = "LSP: [W]orkspace [S]ymbols";
        }
        {
          key = "<leader>rn";
          lspBufAction = "rename";
          options.desc = "LSP: [R]e[n]ame";
        }
        {
          mode = ["n" "x"];
          key = "<leader>ca";
          lspBufAction = "code_action";
          options.desc = "LSP: [C]ode [A]ction";
        }
        # not definition: declaration (in C, the header)
        {
          key = "gD";
          lspBufAction = "declaration";
          options.desc = "LSP: [G]oto [D]eclaration";
        }
      ];

      # `client` and `bufnr` are in scope
      onAttach = ''
        -- highlight other uses of the word under the cursor while it rests there
        if client:supports_method('textDocument/documentHighlight', bufnr) then
          local group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr, group = group, callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr, group = group, callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            buffer = bufnr,
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = false }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = ev.buf }
            end,
          })
        end

        -- inlay hints stay off until toggled
        if client:supports_method('textDocument/inlayHint', bufnr) then
          vim.keymap.set('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
          end, { buffer = bufnr, desc = 'LSP: [T]oggle Inlay [H]ints' })
        end
      '';
    };

    # fix eslint issues on save (only does something once the eslint server above is enabled)
    extraConfigLuaPost = ''
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
        callback = function(event)
          if #vim.lsp.get_clients { bufnr = event.buf, name = 'eslint' } > 0 then
            vim.cmd 'LspEslintFixAll'
          end
        end,
      })
    '';
  };
}
