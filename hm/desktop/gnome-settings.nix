# hm/desktop/gnome-settings.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  # dconf settings for GNOME
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["ctrl:nocaps"];
    };

    "org/gnome/desktop/privacy" = {
      report-technical-problems = false;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "mouse"; # Options: "click", "sloppy", "mouse"
      auto-raise = false; # Set to true if you want windows to auto-raise on focus
      raise-on-click = true;
      num-workspaces = 4;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:";
    };

    # Mouse and touchpad settings
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = 0.5; # Adjust between -1.0 and 1.0
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      speed = 0.6;
    };

    # Additional window management settings
    "org/gnome/desktop/wm/keybindings" = {
      # Disable some default keybindings to avoid conflicts
      show-desktop = ["<Super>D"];
      toggle-maximized = ["<Super>Up"];

      # Workspace switching
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];

      # Move window to workspace
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];

      # Window tiling
      tile-to-side-e = ["<Super>Right"];
      tile-to-side-w = ["<Super>Left"];

      # Close window
      close = ["<Super>Q"];
    };

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

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "ghostty";
      name = "Open Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>E";
      command = "nautilus";
      name = "Open Files";
    };

    # Web Browser
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>W";
      command = "zen-beta"; # or "google-chrome", "chromium", etc.
      name = "Open Browser";
    };

    # Text Editor
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Super><Shift>E";
      command = "ghostty -e nvim"; # or "gedit", "vim", "nvim", etc.
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

    # Dash to Dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dash-max-icon-size = 48;
      show-trash = false;
      show-mounts = false;
      hot-keys = false;
    };

    # Just Perfection settings
    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = true;
      app-menu = false;
      background-menu = true;
      keyboard-layout = true;
      show-apps-button = true;
      workspace-switcher-should-show = false;
    };

    # wirelss-hid settings
    "org/gnome/shell/extensions/wireless-hid" = {
      use-device-levels = true;
    };

    # vitals settings
    "org/gnome/shell/extensions/vitals" = {
      icon-style = 1;
      menu-centered = true;
      show-gpu = false;
      show-system = false;
      show-voltage = false;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false; # enables user extensions
      enabled-extensions = [
        pkgs.gnomeExtensions.appindicator.extensionUuid
        pkgs.gnomeExtensions.dash-to-dock.extensionUuid
        pkgs.gnomeExtensions.user-themes.extensionUuid
        pkgs.gnomeExtensions.vitals.extensionUuid
        pkgs.gnomeExtensions.pano.extensionUuid
        pkgs.gnomeExtensions.caffeine.extensionUuid
        pkgs.gnomeExtensions.hide-top-bar.extensionUuid
        pkgs.gnomeExtensions.media-controls.extensionUuid
        pkgs.gnomeExtensions.just-perfection.extensionUuid
        pkgs.gnomeExtensions.forge.extensionUuid
        pkgs.gnomeExtensions.blur-my-shell.extensionUuid
        pkgs.gnomeExtensions.wireless-hid.extensionUuid
        pkgs.gnomeExtensions.user-avatar-in-quick-settings.extensionUuid
        pkgs.gnomeExtensions.appindicator.extensionUuid
        pkgs.gnomeExtensions.removable-drive-menu.extensionUuid
        pkgs.gnomeExtensions.syncthing-indicator.extensionUuid
        pkgs.gnomeExtensions.hide-cursor.extensionUuid
        pkgs.gnomeExtensions.just-perfection.extensionUuid
      ];
    };
  };

  # GNOME Shell extensions
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    user-themes
    vitals
    pano
    caffeine
    hide-top-bar
    media-controls
    just-perfection
    forge
    blur-my-shell
    wireless-hid
    user-avatar-in-quick-settings
    removable-drive-menu
    syncthing-indicator
  ];
}
