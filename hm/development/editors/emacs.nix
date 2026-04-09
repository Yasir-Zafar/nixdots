{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
  };

  home.packages = with pkgs; [
    clang-tools
    typescript-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    bash-language-server
    yaml-language-server
    python314Packages.python-lsp-server
    pyright
    lua-language-server
    ccls

    alejandra
    stylua
    shfmt

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
