# nixos/desktop/gnome.nix
# GNOME desktop environment configuration
{
  pkgs,
  inputs,
  ...
}: {
  # ============================================================================
  # GNOME Services
  # ============================================================================
  services = {
    gnome = {
      gnome-keyring.enable = true; # Password and secret management
      localsearch.enable = true; # File indexing and search (was Tracker)
      gnome-online-accounts.enable = true; # Online account integration
      sushi.enable = true; # File previewer (spacebar preview)
      at-spi2-core.enable = true; # Accessibility support
      tinysparql.enable = true; # Metadata database (new Tracker)
    };

    desktopManager.gnome.enable = true;

    # Device management and hardware support
    udev.packages = [pkgs.gnome-settings-daemon];

    # Virtual file systems (network shares, MTP devices, etc.)
    gvfs.enable = true;
  };

  # ============================================================================
  # Wayland & X11 Compatibility
  # ============================================================================
  programs.xwayland.enable = true; # X11 app compatibility on Wayland
  programs.dconf.enable = true; # GNOME settings backend

  # ============================================================================
  # Environment Configuration
  # ============================================================================
  environment = {
    # Enable thumbnail support for file managers
    pathsToLink = ["share/thumbnailers"];

    # -------------------------------------------------------------------------
    # GNOME Packages
    # -------------------------------------------------------------------------
    systemPackages = with pkgs; [
      # GNOME Utilities & Extensions
      gnome-tweaks # Advanced GNOME settings
      gnome-extension-manager # Manage GNOME Shell extensions
      dconf-editor # Low-level settings editor

      # GNOME Applications (kept from exclusions)
      gnome-calendar # Calendar app
      gnome-calculator # Calculator
      gnome-usage # System resource monitor
      gnome-disk-utility # Disk management (GNOME Disks)
      gnome-pomodoro # Pomodoro timer
      file-roller # Archive manager

      # Additional Tools
      gnome-autoar # Archive library
      refine # GNOME app (specify what this is)
      nwg-look # GTK theme switcher

      # Theming Support
      sassc # SASS compiler for themes
      gtk-engine-murrine # GTK2 theme engine
      gnome-themes-extra # Additional GTK themes

      # Image Support
      libheif # HEIF/HEIC image format
      libheif.out # HEIF tools

      # Applications
      bitwarden-desktop # Password manager
      inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    ];

    # -------------------------------------------------------------------------
    # Excluded GNOME Packages
    # -------------------------------------------------------------------------
    # Remove default apps to reduce bloat and improve performance
    gnome.excludePackages = with pkgs; [
      # Documentation & Help
      yelp # Help browser
      gnome-user-docs # User documentation
      gnome-tour # Welcome tour

      # Applications (replaced by better alternatives or unused)
      epiphany # GNOME Web (using Zen Browser instead)
      geary # Email client
      evince # Document viewer
      totem # Video player
      cheese # Webcam app
      simple-scan # Scanner app
      gnome-music # Music player
      gnome-photos # Photo manager

      # Utilities (optional - uncomment if needed)
      gnome-maps # Maps application
      gnome-weather # Weather app
      gnome-calendar # Calendar (removed above, add back if needed)
      gnome-clocks # Clocks app
      gnome-characters # Character map
      gnome-logs # Log viewer
      gnome-font-viewer # Font viewer
      gnome-calculator # Calculator (removed above, add back if needed)

      # System Components
      gnome-connections # Remote desktop client
      gnome-console # Terminal (use gnome-terminal or another)
      gnome-initial-setup # First-time setup wizard
      gnome-software # Software center (using Flatpak directly)
      seahorse # Password manager (using Bitwarden)

      # Games (remove if you want them)
      tali # Yahtzee game
      iagno # Reversi game
      hitori # Logic puzzle game
      atomix # Puzzle game
    ];
  };

  # ============================================================================
  # XDG User Directories
  # ============================================================================
  # Configure default user folders (prevents creation of unwanted directories)
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=
    DOWNLOAD=Downloads
    TEMPLATES=
    PUBLICSHARE=
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
}
