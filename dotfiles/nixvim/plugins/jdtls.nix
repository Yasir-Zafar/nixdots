{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    enable = true;
    plugins = {
      jdtls = {
        enable = true;

        # Add additional package dependencies
        jdtLanguageServerPackage = pkgs.jdt-language-server;

        # Java settings
        settings = {
          # Command to start the JDTLS server
          cmd = [
            "jdtls"
            "--jvm-arg=-javaagent:${config.home.homeDirectory}/.local/share/nvim/mason/packages/jdtls/lombok.jar"
            "-data"
            "${config.home.homeDirectory}/.cache/jdtls-workspace"
          ];

          root_dir.__raw = "vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'pom.xml', 'build.gradle'}, { upward = true })[1])";

          java = {
            format = {
              enabled = true;
              settings.__raw = "{ url = vim.fn.expand '$HOME/.local/share/nvim/mason/packages/google-java-format/google-java-format.xml' }";
            };
            signatureHelp.enabled = true;
            contentProvider.preferred = "fernflower";
            completion.favoriteStaticMembers = [
              "org.junit.Assert.*"
              "org.junit.Assume.*"
              "org.junit.jupiter.api.Assertions.*"
              "org.junit.jupiter.api.Assumptions.*"
              "org.junit.jupiter.api.DynamicContainer.*"
              "org.junit.jupiter.api.DynamicTest.*"
            ];
            sources.organizeImports = {
              starThreshold = 9999;
              staticStarThreshold = 9999;
            };
            codeGeneration = {
              toString.template = "\${object.className}{\${member.name()}=\${member.value}, \${otherMembers}}";
              hashCodeEquals.useJava7Objects = true;
              useBlocks = true;
            };
            configuration.runtimes = [
              {
                name = "JavaSE-17";
                path.__raw = "vim.fn.expand '$JAVA_HOME'";
                default = true;
              }
            ];
          };
        };

        # Set up autocommands for Java files
      };
    };
    autoCmd = [
      {
        event = "FileType";
        pattern = "java";
        callback.__raw = ''
          function()
            require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
          end
        '';
      }
    ];

    # Add keymaps and additional setup in on_attach
    extraConfigLua = ''
      -- Java LSP setup
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          -- Set up which-key keymaps for Java
          local wk = require('which-key')
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
          })

          -- Enable format on save
          local client = require('jdtls')
          if client.server_capabilities and client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('JdtlsFormat', { clear = true }),
              buffer = 0,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
      })
    '';

    # Add required dependencies
    extraPlugins = with pkgs.vimPlugins; [
      which-key-nvim
      nvim-dap
    ];
  };
}
