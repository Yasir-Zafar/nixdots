{pkgs, ...}: {
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
      focus-mode = "mouse";
      auto-raise = false;
      raise-on-click = true;
      num-workspaces = 4;
      button-layout = "appmenu:";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = false;
      clock-format = "12h";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
      speed = 0.7;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      speed = 0.7;
    };

    "org/gnome/desktop/wm/keybindings" = {
      show-desktop = ["<Super>D"];
      toggle-maximized = ["<Super>Up"];
      close = ["<Super>Q"];

      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];

      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];

      tile-to-side-e = ["<Super>Right"];
      tile-to-side-w = ["<Super>Left"];
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

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>W";
      command = "zen-beta";
      name = "Open Browser";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Super><Shift>E";
      command = "ghostty -e nvim";
      name = "Open Text Editor";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "Print";
      command = "gnome-screenshot";
      name = "Screenshot";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "<Shift>Print";
      command = "gnome-screenshot -a";
      name = "Screenshot Selection";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
      binding = "<Ctrl><Shift>Escape";
      command = "missioncenter";
      name = "System Monitor";
    };

    # "org/gnome/shell/extensions/dash-to-dock" = {
    #   dock-position = "BOTTOM";
    #   dash-max-icon-size = 48;
    #   show-trash = false;
    #   show-mounts = false;
    #   hot-keys = false;
    # };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = true;
      app-menu = false;
      background-menu = true;
      keyboard-layout = true;
      show-apps-button = true;
      workspace-switcher-should-show = false;
    };

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

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid
        # dash-to-dock.extensionUuid
        user-themes.extensionUuid
        # pano.extensionUuid
        clipboard-indicator.extensionUuid
        caffeine.extensionUuid
        hide-top-bar.extensionUuid
        media-controls.extensionUuid
        just-perfection.extensionUuid
        forge.extensionUuid
        # blur-my-shell.extensionUuid
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
        vitals.extensionUuid
      ];
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    # dash-to-dock
    user-themes
    # pano
    clipboard-indicator
    caffeine
    hide-top-bar
    media-controls
    just-perfection
    forge
    # blur-my-shell
    wireless-hid
    user-avatar-in-quick-settings
    removable-drive-menu
    hide-cursor
    app-hider
    unmess
    simple-workspaces-bar
    steal-my-focus-window
    open-desktop-file-location
    xwayland-indicator
    splash-indicator
    edit-desktop-files
    syncthing-toggle
    wellbeing-toggle
    pip-on-top
    date-menu-formatter
    quick-settings-audio-panel
    vitals
  ];
}
