{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk; # Modern Emacs with pure GTK
  };

  # Install all development tools and LSP servers
  home.packages = with pkgs; [
    # Language servers
    nil # Nix LSP
    clang-tools # clangd for C/C++
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # HTML/CSS/JSON/ESLint
    nodePackages."@tailwindcss/language-server"
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    python311Packages.python-lsp-server
    pyright # Better Python LSP
    gopls # Go LSP
    lua-language-server

    # Node.js ecosystem
    nodejs
    bun
    yarn

    # Python tools
    python313
    python313Packages.black
    python313Packages.isort
    python313Packages.flake8
    python313Packages.pylint
    python313Packages.mypy

    # C/C++ tools
    cmake
    gnumake
    bear # For generating compile_commands.json
    ccls # Alternative C++ LSP

    # Go tools
    go
    gotools
    go-tools

    # Formatters
    nixpkgs-fmt
    alejandra # Better Nix formatter
    rustfmt
    nodePackages.prettier
    nodePackages.eslint
    black
    stylua # Lua formatter
    shfmt # Shell formatter

    # Debuggers
    lldb
    gdb
    python313Packages.debugpy
    delve # Go debugger

    # Tools
    ripgrep
    fd
    fzf
    silver-searcher # ag
    sqlite # For org-roam
    tree-sitter
    git

    # Spell checking
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    hunspell

    # PDF tools
    poppler-utils # For pdf-tools

    # Fonts
    emacs-all-the-icons-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.caskaydia-mono
    source-code-pro
    hack-font
  ];

  # Environment variables - make LSP binaries available
  home.sessionVariables = {
    # EDITOR = "emacs";
    # VISUAL = "emacs";
    LSP_USE_PLISTS = "true"; # Performance boost for LSP
  };

  # Ensure PATH includes development tools
  home.sessionPath = [
    "$HOME/.emacs.d/bin" # Doom Emacs bin if used
    "$HOME/.npm/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
  ];
}
