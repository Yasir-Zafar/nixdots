{
  programs.nixvim = {
    # trouble v3: the old :TroubleToggle command is gone, everything is `:Trouble <source> <action>`
    plugins.trouble.enable = true;
    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
        options.desc = "Buffer diagnostics (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>xq";
        action = "<cmd>Trouble qflist toggle<CR>";
        options.desc = "Quickfix list (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>xt";
        action = "<cmd>Trouble todo toggle<CR>";
        options.desc = "TODO comments (Trouble)";
      }
    ];
  };
}
