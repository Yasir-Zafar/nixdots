# ============================================================================
# Qt Application Theming Configuration
# Location: hm/desktop/qt.nix
# ============================================================================
{pkgs, ...}: {
  # ==========================================================================
  # QT CONFIGURATION
  # ==========================================================================
  qt = {
    enable = true;

    # Use GTK theme for Qt applications
    platformTheme.name = "gtk";

    # Qt style settings
    style = {
      name = "adwaita-dark"; # Match GNOME's dark theme
      package = pkgs.adwaita-qt; # Qt theme that mimics GTK Adwaita
    };
  };

  # ==========================================================================
  # QT ENVIRONMENT VARIABLES
  # ==========================================================================
  home.sessionVariables = {
    # Force Qt to use Adwaita dark theme
    QT_STYLE_OVERRIDE = "adwaita-dark";

    # Additional Qt theming variables (optional)
    QT_QPA_PLATFORMTHEME = "gtk3"; # Use GTK3 platform theme
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # Enable HiDPI scaling
  };

  # ==========================================================================
  # QT PACKAGES (Optional)
  # ==========================================================================
  # Install Qt theming tools if needed
  home.packages = with pkgs; [
    qt5ct # Qt5 configuration tool
    qt6ct # Qt6 configuration tool
    libsForQt5.qtstyleplugins # Additional Qt5 styles
  ];
}
