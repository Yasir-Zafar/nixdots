# ============================================================================
# GTK Theme Configuration
# Location: hm/desktop/gtk.nix
# ============================================================================
{
  pkgs,
  config,
  ...
}: {
  # ==========================================================================
  # GTK CONFIGURATION
  # ==========================================================================
  gtk = {
    enable = true;

    # ------------------------------------------------------------------------
    # GTK Theme
    # ------------------------------------------------------------------------
    theme = {
      name = "Gruvbox-Green-Dark-Medium"; # Your custom theme name
      # For custom themes from dotfiles, don't specify package
      # The theme will be loaded from ~/.themes/
    };

    # ------------------------------------------------------------------------
    # Icon Theme
    # ------------------------------------------------------------------------
    iconTheme = {
      name = "Gruvbox-Plus-Dark"; # Your custom icon theme name
      # For custom icons from dotfiles, don't specify package
      # The icons will be loaded from ~/.icons/
    };

    # ------------------------------------------------------------------------
    # Cursor Theme
    # ------------------------------------------------------------------------
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24; # Cursor size in pixels
    };

    # ------------------------------------------------------------------------
    # Font Configuration
    # ------------------------------------------------------------------------
    font = {
      name = "Inter";
      size = 11;
    };

    # ------------------------------------------------------------------------
    # GTK 3 & 4 Settings
    # ------------------------------------------------------------------------
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:close";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = false;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:close";
    };
  };
}
