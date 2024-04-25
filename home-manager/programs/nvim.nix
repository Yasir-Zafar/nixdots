{ pkgs
, lib
, inputs
, ...
}:
let
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = false;
    colorschemes.gruvbox = {
      enable = true;
    };
    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers

      # autoindent = true;
      # backspace = "indent,eol,start";
      # backup = true;
      cmdheight = 1;
      # colorcolumn = "80";
      /*
        completeopt = "menu,menuone,noselect";
        */
      #
      # conceallevel = 0;
      # cursorline = true;
      # expandtab = true;
      # foldenable = true;
      # foldexpr = "nvim_treesitter#foldexpr()";
      # foldlevel = 5;
      # foldmethod = "expr";
      # ignorecase = true;
      # laststatus = 3;
      # mouse = "a";
      /*
        pumheight = 0;
        */
      shiftwidth = 2;
      # showtabline = 1;
      # signcolumn = "yes";
      # smartcase = true;
      # tabstop = 4;
      # termguicolors = true;
      # timeoutlen = 300;
      # undofile = true;
      # updatetime = 300;
      wrap = false;
      # writebackup = true;
      clipboard = "unnamedplus";
    };
    plugins = {
      lualine.enable = true;
      toggleterm.enable = true;
      which-key.enable = true;
      vim-css-color.enable = true;
      nvim-colorizer.enable = true;
      telescope.enable = true;
      comment.enable = true;
      neo-tree.enable = true;
      lsp.servers.pyright.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp.enable = true;
      treesitter.enable = true;
      lsp.enable = true;
      gitignore.enable=true;
      cmp.settings = {
        sources = [
          { name = "nvim_lsp"; }
        ];
      };

      nvim-autopairs = {
        enable = true;
      };
    };
    autoCmd = [
      {
        event = [ "TermOpen" ];
        pattern = [ "*" ];
        command = "startinsert";
      }
    ];
  };
}
