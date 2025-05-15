{pkgs, ...}: {
  # Enable the Noice plugin
  programs.nixvim.plugins.noice = {
    enable = true;
    settings = {
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
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "nui.nvim";
      version = "2024-05-14"; # Use today's date or latest tag if known
      src = pkgs.fetchFromGitHub {
        owner = "MunifTanjim";
        repo = "nui.nvim";
        rev = "f535005e6ad1016383f24e39559833759453564e"; # Or use a specific commit SHA for more stability
        sha256 = "sha256-SJc9nfV6cnBKYwRWsv0iHy+RbET8frNV85reICf+pt8="; # Replace this
      };
    })
  ];
}
