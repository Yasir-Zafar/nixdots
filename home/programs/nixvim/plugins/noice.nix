{pkgs, ...}: {
  # Enable the Noice plugin
  programs.nixvim.plugins.noice = {
    enable = true;

    # LSP configuration
    lsp = {
      override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };
    };

    # Enable presets
    presets = {
      bottom_search = true;
      command_palette = true;
      long_message_to_split = true;
      inc_rename = false;
      lsp_doc_border = false;
    };
  };

  # Enable and configure nvim-notify
  programs.nixvim.plugins.notify = {
    enable = true;

    # Set as the global notification handler (autoloaded by plugin)
    settings = {
      background_colour = "#000000";
    };
  };

  # Add dependencies
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    nui-nvim # Required for noice
  ];
}
