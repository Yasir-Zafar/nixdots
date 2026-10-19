{pkgs, ...}: {
  programs.nixvim = {
    # linters below that nothing else installs (eslint, statix, markdownlint-cli2, vale, hadolint come from the profile)
    extraPackages = [
      pkgs.luajitPackages.luacheck
      pkgs.python3Packages.flake8
    ];

    # Linting
    # https://nix-community.github.io/nixvim/plugins/lint/index.html
    plugins.lint = {
      enable = true;

      # NOTE: Enabling these will cause errors unless these tools are installed
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
        markdown = [
          "markdownlint-cli2"
          "vale"
        ];
        python = ["flake8"];
        #clojure = ["clj-kondo"];
        dockerfile = ["hadolint"];
        #inko = ["inko"];
        #janet = ["janet"];
        # json = ["jsonlint"];
        #rst = ["vale"];
        #ruby = ["ruby"];
        #terraform = ["tflint"];
        text = ["vale"];
      };

      # Create autocommand which carries out the actual linting
      # on the specified events.
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

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      lint = {
        clear = true;
      };
    };
  };
}
