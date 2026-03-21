{pkgs, ...}: {
  home.packages = with pkgs; [
    # Modern core utilities
    eza
    bat
    fd
    ripgrep
    fzf
    zoxide
    procs
    dust
    duf

    # File tools
    tree
    ncdu
    unzip
    p7zip
    unrar

    # Nix helpers
    nh
    nix-tree
    nix-output-monitor
    nvd

    # Dev utilities
    just
    direnv
  ];
}
