# ===== hm/applications/utilities.nix =====
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # File managers
    nautilus # GNOME file manager
    yazi # Terminal file manager

    # Archive tools
    unzip
    p7zip
    unrar

    # System utilities
    htop
    btop # Modern htop alternative
    neofetch
    tree

    # File utilities
    fd # Modern find
    ripgrep # Modern grep
    fzf # Fuzzy finder
    bat # Modern cat with syntax highlighting
    exa # Modern ls

    # Calculator and productivity
    gnome-calculator
  ];

  programs = {
    # Configure some utilities
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
      config = {
        theme = "Gruvbox";
        pager = "less -FR";
      };
    };

    eza = {
      enable = true;
      enableAliases = true;
    };
  };
}
