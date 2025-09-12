{pkgs, ...}: {
  programs.nixvim = {
    # Add required dependencies
    extraPackages = with pkgs; [
      stylua                      # Lua formatter
      alejandra                   # Nix formatter
      nodePackages.prettier       # JS/TS/HTML/CSS/JSON formatter
      google-java-format          # Java formatter
    ];

    # Conform.nvim formatter config
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save = ''
          function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            return {
              timeout_ms = 500,
              lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype]
            }
          end
        '';
        formatters_by_ft = {
          lua = ["stylua"];
          nix = ["alejandra"];
          java = ["google_java_format"];
          javascript = ["prettier"];
          typescript = ["prettier"];
          javascriptreact = ["prettier"];
          typescriptreact = ["prettier"];
          json = ["prettier"];
          html = ["prettier"];
          css = ["prettier"];
          # Run multiple formatters sequentially: python = ["isort" "black"];
          # Use first available: javascript = [["prettierd" "prettier"]];
        };
      };
    };

    # Format buffer keybinding
    keymaps = [
      {
        mode = "";
        key = "<leader>f";
        action.__raw = ''
          function() 
            require('conform').format { async = true, lsp_fallback = true } 
          end
        '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
    ];
  };
}
