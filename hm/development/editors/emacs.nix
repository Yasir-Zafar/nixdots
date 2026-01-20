{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk; # Modern Emacs with pure GTK
    extraPackages = epkgs:
      with epkgs; [
        # Core dependencies for literate config
        use-package
        org
        org-contrib

        # Essential utilities
        which-key
        diminish

        # Git dependencies
        magit
        diff-hl
        git-gutter

        # Completion framework
        vertico
        orderless
        consult
        embark
        embark-consult
        marginalia
        corfu
        cape

        # Project management
        projectile
        perspective

        # File management
        dired-sidebar
        all-the-icons
        all-the-icons-dired

        # Language support
        tree-sitter
        tree-sitter-langs
        eglot

        # Writing
        markdown-mode
        yaml-mode

        # Programming
        nix-mode
        rust-mode
        python-mode
        web-mode
        typescript-mode

        # Org mode extensions
        org-roam
        org-appear
        org-modern

        # UI enhancements
        doom-modeline
        doom-themes
        rainbow-delimiters
        highlight-indent-guides

        # Misc
        exec-path-from-shell
        helpful
        pdf-tools
      ];
  };

  # home.file.".emacs.d/init.el".text = ''
  #   ;; Bootstrap literate configuration
  #   (require 'org)
  #   (org-babel-load-file "~/.emacs.d/config.org")
  # '';
  #
  # home.file.".emacs.d/config.org".source = ./emacs-config.org;

  # Additional dependencies
  home.packages = with pkgs; [
    # Language servers
    nil # Nix LSP
    rust-analyzer
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # HTML/CSS/JSON
    python311Packages.python-lsp-server

    # Formatters
    nixpkgs-fmt
    rustfmt
    nodePackages.prettier
    black

    # Tools
    ripgrep
    fd
    sqlite # For org-roam

    # Fonts
    emacs-all-the-icons-fonts
    (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode"];})
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "emacs";
    VISUAL = "emacs";
  };
}
