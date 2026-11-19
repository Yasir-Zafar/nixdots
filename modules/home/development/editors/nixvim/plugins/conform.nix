{pkgs, ...}: {
  programs.nixvim = {
    # Add required dependencies
    extraPackages = with pkgs; [
      stylua # Lua formatter
      alejandra # Nix formatter
      prettier # JS/TS/HTML/CSS/JSON/YAML/Markdown formatter
      ruff # python formatter + import sorting (and the linter in lint.nix)
      rustfmt
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
              lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
            }
          end
        '';
        formatters_by_ft = {
          rust = ["rustfmt"];
          lua = ["stylua"];
          nix = ["alejandra"];
          # the same formatters as Emacs (apheleia), so a file comes out identical in both
          javascript = ["prettier"];
          typescript = ["prettier"];
          javascriptreact = ["prettier"];
          typescriptreact = ["prettier"];
          json = ["prettier"];
          jsonc = ["prettier"];
          yaml = ["prettier"];
          markdown = ["prettier"];
          html = ["prettier"];
          css = ["prettier"];
          python = ["ruff_organize_imports" "ruff_format"]; # run in sequence
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
            require('conform').format { async = true, lsp_format = "fallback" }
          end
        '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
    ];
  };
}
