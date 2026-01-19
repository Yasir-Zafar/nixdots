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

  # ==========================================================================
  # CUSTOM THEME FILES FROM DOTFILES
  # ==========================================================================
  # Symlink your custom themes and icons from dotfiles directory

  # Option 1: If your dotfiles are in ~/dotfiles
  home.file = {
    # GTK Themes
    ".themes/Gruvbox-Dark-BL".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/themes/gtk/Gruvbox-Green-Dark-Medium";

    # Add more themes if needed
    # ".themes/AnotherTheme".source = config.lib.file.mkOutOfStoreSymlink
    #   "${config.home.homeDirectory}/dotfiles/themes/gtk/AnotherTheme";

    # Icon Themes
    ".icons/Gruvbox-Plus-Dark".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/themes/icons/Gruvbox-Plus-Dark";

    # Add more icon themes if needed
    # ".icons/AnotherIconTheme".source = config.lib.file.mkOutOfStoreSymlink
    #   "${config.home.homeDirectory}/dotfiles/themes/icons/AnotherIconTheme";
  };

  # Option 2: If themes are in your NixOS configuration directory
  # home.file = {
  #   ".themes/Gruvbox-Dark-BL".source = ../../../themes/gtk/Gruvbox-Dark-BL;
  #   ".icons/Gruvbox-Plus-Dark".source = ../../../themes/icons/Gruvbox-Plus-Dark;
  # };

  # ==========================================================================
  # SESSION VARIABLES
  # ==========================================================================
  home.sessionVariables = {
    # Force GTK applications to use dark theme
    GTK_THEME = "Gruvbox-Green-Dark-Medium";

    # Ensure proper theme loading
    GTK2_RC_FILES = "${config.home.homeDirectory}/.gtkrc-2.0";
  };

  # ==========================================================================
  # ADDITIONAL PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    # Theme tools
    nwg-look # GTK theme switcher and configurator
    sassc # Sass compiler for custom themes

    # GTK theme support
    gnome-themes-extra # Additional GTK themes
    gtk-engine-murrine # Theme engine for GTK
  ];
}
# ============================================================================
# DOTFILES THEME ORGANIZATION
# ============================================================================
# Recommended directory structure for your dotfiles:
#
# ~/dotfiles/
# ├── themes/
# │   ├── gtk/
# │   │   ├── Gruvbox-Green-Dark-Medium/
# │   │   │   ├── gtk-2.0/
# │   │   │   ├── gtk-3.0/
# │   │   │   ├── gtk-4.0/
# │   │   │   └── index.theme
# │   │   └── OtherTheme/
# │   │       └── ...
# │   └── icons/
# │       ├── Gruvbox-Plus-Dark/
# │       │   ├── index.theme
# │       │   ├── 16x16/
# │       │   ├── 22x22/
# │       │   └── ...
# │       └── OtherIcons/
# │           └── ...
# └── ...
#
# ============================================================================
# ============================================================================
# USAGE INSTRUCTIONS
# ============================================================================
# 1. Create the dotfiles directory structure above
#
# 2. Copy your themes from ~/.themes to ~/dotfiles/themes/gtk/
#    Example: cp -r ~/.themes/Gruvbox-Green-Dark-Medium ~/dotfiles/themes/gtk/
#
# 3. Copy your icons from ~/.icons to ~/dotfiles/themes/icons/
#    Example: cp -r ~/.icons/Gruvbox-Plus-Dark ~/dotfiles/themes/icons/
#
# 4. Update the paths in home.file above to match your setup
#
# 5. Rebuild your NixOS configuration:
#    sudo nixos-rebuild switch --flake .#yourhostname
#
# 6. The themes will be automatically symlinked to ~/.themes and ~/.icons
#
# ============================================================================

