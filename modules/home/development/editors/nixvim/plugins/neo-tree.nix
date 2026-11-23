{
  programs.nixvim = {
    # file tree
    plugins.neo-tree = {
      enable = true;

      settings = {
        filesystem = {
          window = {
            mappings = {
              "\\" = "close_window";
            };
          };
        };
      };
    };

    keymaps = [
      {
        key = "\\";
        action = "<cmd>Neotree reveal<cr>";
        options = {
          desc = "NeoTree reveal";
        };
      }
    ];
  };
}
