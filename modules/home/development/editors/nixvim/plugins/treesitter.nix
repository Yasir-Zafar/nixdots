{config, ...}: {
  programs.nixvim = {
    # highlight, edit, navigate code
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent = {
        enable = true;
        disable = ["ruby"];
      };
      folding.enable = true; # foldexpr from the syntax tree; fold levels are in editor.nix

      # only grammars I use; add one for missing highlighting
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
