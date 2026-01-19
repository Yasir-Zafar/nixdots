# ============================================================================
# Desktop Environment Configuration
# Location: hm/desktop/default.nix
# ============================================================================
{pkgs, ...}: {
  imports = [
    ./gnome-settings.nix # GNOME desktop settings and extensions
    ./gtk.nix # GTK theme configuration
    ./qt.nix # Qt application theming
  ];

  # ==========================================================================
  # DESKTOP PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # System Monitoring
    # ------------------------------------------------------------------------
    htop # Interactive process viewer
    btop # Modern resource monitor
    powertop # Power consumption analyzer

    # ------------------------------------------------------------------------
    # Theme & Appearance Tools
    # ------------------------------------------------------------------------
    nwg-look # GTK theme manager
    sassc # Sass/SCSS compiler for themes
    gnome-themes-extra # Additional GTK themes
    gtk-engine-murrine # GTK theme engine

    # ------------------------------------------------------------------------
    # Cursor Theme
    # ------------------------------------------------------------------------
    bibata-cursors # Modern cursor theme

    # ------------------------------------------------------------------------
    # File Manager Extensions
    # ------------------------------------------------------------------------
    nautilus-open-any-terminal # Open terminal from Nautilus
  ];
}
