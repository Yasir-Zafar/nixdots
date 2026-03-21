{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
  };

  home.packages = with pkgs; [
    nil
    clang-tools
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages."@tailwindcss/language-server"
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    python314Packages.python-lsp-server
    pyright
    gopls
    lua-language-server

    nodejs
    bun
    yarn

    gnumake
    bear
    ccls

    alejandra
    nodePackages.prettier
    nodePackages.eslint
    stylua
    shfmt

    ripgrep
    fd
    fzf
    sqlite
    tree-sitter
    emacs-lsp-booster
    libtool

    (aspellWithDicts (dicts:
      with dicts; [
        fr
        en
        en-computers
        en-science
      ]))
    hunspell

    poppler-utils

    emacs-all-the-icons-fonts
    nerd-fonts.jetbrains-mono
    source-code-pro
    hack-font
  ];

  home.sessionVariables = {
    LSP_USE_PLISTS = "true";
  };

  home.sessionPath = [
    "$HOME/.emacs.d/bin"
    "$HOME/.npm/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "${pkgs.aspell}/bin"
  ];
}
