# ============================================================================
# GNOME Desktop Environment Configuration
# Location: hm/desktop/gnome-settings.nix
# ============================================================================
# This file configures GNOME desktop settings using dconf, including:
# - Window management and workspaces
# - Keyboard shortcuts and keybindings
# - Input devices (mouse, touchpad)
# - GNOME Shell extensions
# ============================================================================
{pkgs, ...}: {
  # ==========================================================================
  # DCONF SETTINGS
  # ==========================================================================
  dconf.settings = {
    # ------------------------------------------------------------------------
    # Input & Keyboard Configuration
    # ------------------------------------------------------------------------
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["ctrl:nocaps"]; # Remap Caps Lock to Ctrl
    };

    # ------------------------------------------------------------------------
    # Privacy & Telemetry
    # ------------------------------------------------------------------------
    "org/gnome/desktop/privacy" = {
      report-technical-problems = false; # Disable crash reporting
    };

    # ------------------------------------------------------------------------
    # Calendar & Time
    # ------------------------------------------------------------------------
    "org/gnome/desktop/calendar" = {
      show-weekdate = true; # Show week numbers in calendar
    };

    # ------------------------------------------------------------------------
    # Window Management
    # ------------------------------------------------------------------------
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "mouse"; # Focus follows mouse
      auto-raise = false; # Don't auto-raise focused windows
      raise-on-click = true; # Raise window when clicked
      num-workspaces = 4; # Fixed number of workspaces
      button-layout = "appmenu:"; # Remove window control buttons
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false; # Use fixed workspaces
    };

    # ------------------------------------------------------------------------
    # Interface Appearance
    # ------------------------------------------------------------------------
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark"; # Dark theme preference
      enable-hot-corners = false; # Disable hot corners
      show-battery-percentage = false; # Hide battery percentage
      clock-format = "12h"; # 12-hour time format
    };

    # ------------------------------------------------------------------------
    # Mouse Configuration
    # ------------------------------------------------------------------------
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false; # Traditional scroll direction
      speed = 0.7; # Mouse sensitivity (-1.0 to 1.0)
    };

    # ------------------------------------------------------------------------
    # Touchpad Configuration
    # ------------------------------------------------------------------------
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true; # Natural (macOS-style) scrolling
      tap-to-click = true; # Enable tap to click
      two-finger-scrolling-enabled = true; # Two-finger scroll
      speed = 0.7; # Touchpad sensitivity
    };

    # ------------------------------------------------------------------------
    # Window Manager Keybindings
    # ------------------------------------------------------------------------
    "org/gnome/desktop/wm/keybindings" = {
      # Desktop & Window Controls
      show-desktop = ["<Super>D"];
      toggle-maximized = ["<Super>Up"];
      close = ["<Super>Q"];

      # Workspace Switching
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];

      # Move Window to Workspace
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];

      # Window Tiling
      tile-to-side-e = ["<Super>Right"];
      tile-to-side-w = ["<Super>Left"];
    };

    # ------------------------------------------------------------------------
    # Custom Application Keybindings
    # ------------------------------------------------------------------------
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
      ];
    };

    # Terminal
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "ghostty";
      name = "Open Terminal";
    };

    # File Manager
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>E";
      command = "nautilus";
      name = "Open Files";
    };

    # Web Browser
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>W";
      command = "zen-beta";
      name = "Open Browser";
    };

    # Text Editor
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Super><Shift>E";
      command = "ghostty -e nvim";
      name = "Open Text Editor";
    };

    # Screenshot (Full Screen)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "Print";
      command = "gnome-screenshot";
      name = "Screenshot";
    };

    # Screenshot (Selection)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "<Shift>Print";
      command = "gnome-screenshot -a";
      name = "Screenshot Selection";
    };

    # Lock Screen
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      binding = "<Super>L";
      command = "gnome-screensaver-command --lock";
      name = "Lock Screen";
    };

    # System Monitor
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
      binding = "<Ctrl><Shift>Escape";
      command = "missioncenter";
      name = "System Monitor";
    };

    # ------------------------------------------------------------------------
    # Extension Settings - Dash to Dock
    # ------------------------------------------------------------------------
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dash-max-icon-size = 48;
      show-trash = false;
      show-mounts = false;
      hot-keys = false;
    };

    # ------------------------------------------------------------------------
    # Extension Settings - Just Perfection
    # ------------------------------------------------------------------------
    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = true;
      app-menu = false;
      background-menu = true;
      keyboard-layout = true;
      show-apps-button = true;
      workspace-switcher-should-show = false;
    };

    # ------------------------------------------------------------------------
    # Extension Settings - Other Extensions
    # ------------------------------------------------------------------------
    "org/gnome/shell/extensions/wireless-hid" = {
      use-device-levels = true;
    };

    "org/gnome/shell/extensions/quick-settings-avatar" = {
      avatar-position = 1;
    };

    "org/gnome/shell/extensions/vitals" = {
      icon-style = 1;
      menu-centered = true;
      show-gpu = false;
      show-voltage = false;
    };

    # ------------------------------------------------------------------------
    # GNOME Shell Extensions List
    # ------------------------------------------------------------------------
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid
        dash-to-dock.extensionUuid
        user-themes.extensionUuid
        pano.extensionUuid
        caffeine.extensionUuid
        hide-top-bar.extensionUuid
        media-controls.extensionUuid
        just-perfection.extensionUuid
        forge.extensionUuid
        blur-my-shell.extensionUuid
        wireless-hid.extensionUuid
        user-avatar-in-quick-settings.extensionUuid
        removable-drive-menu.extensionUuid
        hide-cursor.extensionUuid
        app-hider.extensionUuid
        unmess.extensionUuid
        simple-workspaces-bar.extensionUuid
        steal-my-focus-window.extensionUuid
        open-desktop-file-location.extensionUuid
        xwayland-indicator.extensionUuid
        splash-indicator.extensionUuid
        edit-desktop-files.extensionUuid
        syncthing-toggle.extensionUuid
        wellbeing-toggle.extensionUuid
        pip-on-top.extensionUuid
        date-menu-formatter.extensionUuid
        quick-settings-audio-panel.extensionUuid
      ];
    };
  };

  # ==========================================================================
  # GNOME SHELL EXTENSIONS PACKAGES
  # ==========================================================================
  home.packages = with pkgs.gnomeExtensions; [
    # Core functionality
    appindicator # System tray support
    dash-to-dock # Dock/taskbar
    user-themes # Custom theme support

    # Clipboard & productivity
    pano # Clipboard manager
    caffeine # Prevent screen lock

    # UI enhancements
    hide-top-bar # Auto-hide top bar
    media-controls # Media playback controls
    just-perfection # GNOME tweaks
    forge # Window tiling
    blur-my-shell # UI blur effects

    # System utilities
    wireless-hid # Wireless device battery
    user-avatar-in-quick-settings # Avatar in quick settings
    removable-drive-menu # Drive management
    hide-cursor # Auto-hide cursor

    # Workspace & window management
    app-hider # Hide applications
    unmess # Window management
    simple-workspaces-bar # Workspace indicator
    steal-my-focus-window # Window focus control

    # Developer tools
    open-desktop-file-location # File location shortcuts
    xwayland-indicator # X11/Wayland indicator
    splash-indicator # Application splash screen
    edit-desktop-files # .desktop file editor

    # Integration
    syncthing-toggle # Syncthing control
    wellbeing-toggle # Wellbeing features
    pip-on-top # Picture-in-picture
    date-menu-formatter # Custom date format
    quick-settings-audio-panel # Audio controls

    # Monitoring (commented out by default)
    # vitals # System monitoring
  ];
}
