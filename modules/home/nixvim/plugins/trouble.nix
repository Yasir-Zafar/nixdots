{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings = {
        useDiagnosticSigns = true; # Uses your sign column symbols
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>TroubleToggle<CR>";
        options.desc = "Toggle Trouble";
      }
    ];
  };
}
