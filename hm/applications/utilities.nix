# ===== hm/applications/utilities.nix =====
{pkgs, ...}: {
  home.packages = with pkgs; [
    # File managers
    nautilus

    # Productivity
    gnome-calculator
    gnome-feeds

    # System Tools
    pavucontrol
    mission-center
    btop
    htop
    unrar

    # Utilities
    protonvpn-gui
    gearlever
    parabolic
    fragments
    pinta
    aria2
    libnotify
    gnome-decoder
    gnome-notes

    # Optional dependencies
    gnome-epub-thumbnailer
  ];
}
