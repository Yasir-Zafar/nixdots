# hm/desktop/gnome-settings.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  # dconf settings for GNOME
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false; # enables user extensions
      enabled-extensions = [
        pkgs.gnomeExtensions.appindicator.extensionUuid
        pkgs.gnomeExtensions.dash-to-dock.extensionUuid
        pkgs.gnomeExtensions.user-themes.extensionUuid
        pkgs.gnomeExtensions.vitals.extensionUuid
        # pkgs.gnomeExtensions.clipboard-indicator.extensionUuid
        pkgs.gnomeExtensions.pano.extensionUuid
        pkgs.gnomeExtensions.caffeine.extensionUuid
        pkgs.gnomeExtensions.hide-top-bar.extensionUuid
        pkgs.gnomeExtensions.media-progress.extensionUuid
        pkgs.gnomeExtensions.just-perfection.extensionUuid
        # pkgs.gnomeExtensions.forge.extensionUuid
      ];
    };

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

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
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
  };

  # GNOME Shell extensions
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    user-themes
    vitals
    # clipboard-indicator
    pano
    caffeine
    hide-top-bar
    media-progress
    just-perfection
  ];
}
