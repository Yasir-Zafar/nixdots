# the editor features VS Code has out of the box that kickstart lacks:
# outline, project search & replace, diff / file history, session restore, folding, inline diagnostics
{
  programs.nixvim = {
    opts = {
      # folds come from treesitter (treesitter.nix); everything open when a file is loaded (za / zM / zR)
      foldlevel = 99;
      foldlevelstart = 99;
      foldtext = "";
      sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";
    };

    # error text at the end of the line like VS Code's problem lens (K = hover, <leader>e = float)
    diagnostic.settings = {
      virtual_text = {
        spacing = 2;
        source = "if_many";
      };
      severity_sort = true;
      float = {
        border = "rounded";
        source = true;
      };
    };

    plugins = {
      # symbol outline (VS Code's outline / breadcrumbs)
      aerial.enable = true;

      # Ctrl+Shift+H: search and replace across the project
      grug-far.enable = true;

      # side-by-side diffs, per-file history (VS Code's timeline), merge conflicts
      diffview.enable = true;

      # reopen the files of the last session in this directory
      persistence.enable = true;
    };

    keymaps = let
      map = mode: key: action: desc: {
        inherit mode key action;
        options = {inherit desc;};
      };
    in [
      (map "n" "<leader>bd" "<cmd>bdelete<cr>" "[B]uffer [d]elete")

      (map "n" "<leader>o" "<cmd>AerialToggle! right<cr>" "[O]utline")

      (map "n" "<leader>e" "<cmd>lua vim.diagnostic.open_float()<cr>" "Diagnostic [e]rror float")

      {
        mode = "n";
        key = "<leader>sR";
        action.__raw = "function() require('grug-far').open() end";
        options.desc = "[S]earch and [R]eplace";
      }
      {
        mode = "v";
        key = "<leader>sR";
        action.__raw = "function() require('grug-far').with_visual_selection() end";
        options.desc = "[S]earch and [R]eplace selection";
      }

      (map "n" "<leader>gd" "<cmd>DiffviewOpen<cr>" "[G]it [d]iff view")
      (map "n" "<leader>gh" "<cmd>DiffviewFileHistory %<cr>" "[G]it file [h]istory")
      (map "n" "<leader>gH" "<cmd>DiffviewFileHistory<cr>" "[G]it repo [H]istory")
      (map "n" "<leader>gq" "<cmd>DiffviewClose<cr>" "[G]it diff view [q]uit")

      {
        mode = "n";
        key = "<leader>Ss";
        action.__raw = "function() require('persistence').load() end";
        options.desc = "[S]ession [s]restore (this directory)";
      }
      {
        mode = "n";
        key = "<leader>Sl";
        action.__raw = "function() require('persistence').load({ last = true }) end";
        options.desc = "[S]ession restore [l]ast";
      }
      {
        mode = "n";
        key = "<leader>Sd";
        action.__raw = "function() require('persistence').stop() end";
        options.desc = "[S]ession [d]on't save this one";
      }
    ];
  };
}
