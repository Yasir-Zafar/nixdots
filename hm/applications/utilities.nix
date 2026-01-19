# ============================================================================
# System Utilities Configuration
# Location: hm/applications/utilities.nix
# ============================================================================
{pkgs, ...}: {
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # File Managers
    # ------------------------------------------------------------------------
    nautilus # GNOME Files (default file manager)

    # ------------------------------------------------------------------------
    # System Monitoring
    # ------------------------------------------------------------------------
    mission-center # Modern system monitor (GUI)
    btop # Beautiful terminal resource monitor
    htop # Interactive process viewer
    powertop # Power consumption monitor (for laptops)

    # ------------------------------------------------------------------------
    # Productivity Tools
    # ------------------------------------------------------------------------
    gnome-calculator # Calculator
    gnome-feeds # RSS feed reader

    # ------------------------------------------------------------------------
    # Archive & Compression
    # ------------------------------------------------------------------------
    p7zip
    unrar # RAR archive extraction

    # ------------------------------------------------------------------------
    # Network & VPN
    # ------------------------------------------------------------------------
    protonvpn-gui # ProtonVPN client

    # ------------------------------------------------------------------------
    # Utilities
    # ------------------------------------------------------------------------
    gearlever # AppImage manager
    libnotify # Desktop notifications (dependency)
    gnome-decoder # QR code scanner

    # ------------------------------------------------------------------------
    # Theme & Appearance Tools
    # ------------------------------------------------------------------------
    nwg-look # GTK theme configurator
    sassc # Sass/SCSS compiler (for custom themes)
  ];
}
