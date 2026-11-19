{
  imports = [
    ./lsp.nix
    ./rust.nix
    ./conform.nix
    ./gitsigns.nix
    ./blink-cmp.nix
    ./mini.nix
    ./telescope.nix
    ./treesitter.nix
    ./which-key.nix
    ./todo.nix
    # ./tss-tools.nix
    ./trouble.nix
    ./workflow.nix
    ./dap.nix
    ./editor.nix

    # from kickstart.nvim's optional plugins
    ./autopairs.nix
    #./debug.nix
    ./indent-blankline.nix
    ./lint.nix
    ./neo-tree.nix
  ];
}
