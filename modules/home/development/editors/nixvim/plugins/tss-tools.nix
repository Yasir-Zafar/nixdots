{
  programs.nixvim = {
    enable = true;
    plugins.typescript-tools = {
      enable = true;

      settings = {
        settings = {
          separate_diagnostic_server = true;
          tsserver_locale = "en";
          tsserver_plugins = ["@styled/typescript-styled-plugin"];
          codeLens = "off";
          jsx_close_tag = {
            enable = true;
            filetypes = ["javascriptreact" "typescriptreact"];
          };

          on_attach = ''
            function(client, bufnr)
              local wk = require("which-key")
              wk.register({
                ["<leader>T"] = {
                  name = "+TypeScript",
                  o = { "<cmd>TSToolsOrganizeImports<CR>", "Organize Imports" },
                  R = { "<cmd>TSToolsRenameFile<CR>", "Rename File" },
                  i = { "<cmd>TSToolsAddMissingImports<CR>", "Add Missing Imports" },
                  F = { "<cmd>TSToolsFixAll<CR>", "Fix All" },
                  u = { "<cmd>TSToolsRemoveUnused<CR>", "Remove Unused" },
                  s = { "<cmd>TSToolsSortImports<CR>", "Sort Imports" },
                },
              }, { buffer = bufnr })
            end
          '';
        };
      };
    };
  };
}
