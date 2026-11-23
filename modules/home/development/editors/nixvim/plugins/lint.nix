{pkgs, ...}: {
  programs.nixvim = {
    # linters nothing else installs (eslint, statix, hadolint: profile; ruff: conform.nix)
    extraPackages = [
      pkgs.luajitPackages.luacheck
    ];

    # Linting
    plugins.lint = {
      enable = true;

      lintersByFt = {
        # rust = ["rust-clippy"]; # nvim-lint has no linter of that name (it errors on every rust buffer);
        # rust-analyzer already runs clippy on save, see lsp.nix
        lua = ["luacheck"];
        # java = ["checkstyle"];
        javascript = ["eslint"];
        typescript = ["eslint"];
        # c = ["clang-tidy"];
        # cpp = ["clang-tidy"];
        nix = ["statix"];
        # markdown / text: off. vale flags every proper noun as a typo and markdownlint
        # every long line or inline <div>, which buried READMEs in diagnostics
        # markdown = ["markdownlint-cli2" "vale"];
        python = ["ruff"];
        #clojure = ["clj-kondo"];
        dockerfile = ["hadolint"];
        #inko = ["inko"];
        #janet = ["janet"];
        # json = ["jsonlint"];
        #rst = ["vale"];
        #ruby = ["ruby"];
        #terraform = ["tflint"];
        # text = ["vale"];
      };

      autoCmd = {
        callback.__raw = ''
          function()
            require('lint').try_lint()
          end
        '';
        group = "lint";
        event = [
          "BufEnter"
          "BufWritePost"
          "InsertLeave"
        ];
      };
    };

    autoGroups = {
      lint = {
        clear = true;
      };
    };
  };
}
