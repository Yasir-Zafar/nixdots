{
  programs.nixvim = {
    enable = true;

    plugins = {
      lazy.enable = true;
      cmp.enable = true;
      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      luasnip.enable = true;
      lspkind.enable = true;
      telescope.enable = true;
      telescope-fzf-native.enable = true;
      telescope-ui-select.enable = true;
      treesitter.enable = true;
      which-key.enable = true;
      todo-comments.enable = true;
      noice.enable = true;
      nui.enable = true;
      nvim-notify.enable = true;
      indent-blankline.enable = true;
      gitsigns.enable = true;

      extraPlugins = with pkgs.vimPlugins; [
        flutter-tools-nvim
        dressing-nvim
        fidget-nvim
        mini-nvim
        typescript-tools-nvim
        vim-sleuth
        nvim-dap
        nvim-dap-ui
        nvim-dap-go
        mason-nvim-dap-nvim
        nvim-web-devicons
        schemastore-nvim
        plenary-nvim
        gruvbox-nvim
      ];
    };

    colorscheme = "gruvbox";

    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options.desc = "Format";
      }
    ];

    extraConfigLua = ''
      vim.o.termguicolors = true
    '';
  };
}
