{config, ...}: {
  programs.nixvim = {
    # Highlight, edit, and navigate code. nixvim follows nvim-treesitter's `main` branch: the
    # features are top-level options and the grammars are listed below.
    # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent = {
        enable = true;
        disable = ["ruby"];
      };
      folding.enable = true; # foldexpr from the syntax tree; fold levels are in editor.nix

      # the languages used here (was every grammar in nixpkgs, ~320: each lock bump rebuilt
      # and downloaded all of them). Missing highlighting in a file type: add its grammar
      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
        bash
        c
        cmake
        comment
        cpp
        css
        diff
        dockerfile
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        gomod
        html
        ini
        java
        javascript
        jsdoc
        json
        just
        kdl
        lua
        luadoc
        make
        markdown
        markdown_inline
        nix
        printf
        python
        query
        regex
        rust
        sql
        toml
        tsx
        typescript
        vim
        vimdoc
        xml
        yaml
        yuck
      ];
    };

    plugins.treesitter-textobjects.enable = true;
    plugins.treesitter-context.enable = true; # sticky function / block header at the top
  };
}
