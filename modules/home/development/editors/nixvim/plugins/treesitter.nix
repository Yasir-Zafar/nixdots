{
  programs.nixvim = {
    # Highlight, edit, and navigate code. nixvim follows nvim-treesitter's `main` branch: the
    # features are top-level options and every grammar from nixpkgs is installed (grammarPackages).
    # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent = {
        enable = true;
        disable = ["ruby"];
      };
      folding.enable = true; # foldexpr from the syntax tree; fold levels are in editor.nix
    };

    plugins.treesitter-textobjects.enable = true;
    plugins.treesitter-context.enable = true; # sticky function / block header at the top
  };
}
