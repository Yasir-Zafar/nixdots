# hm/desktop/gnome-settings.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  # GNOME Shell extensions
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    user-themes
    vitals
    clipboard-indicator
    blur-my-shell
    workspace-indicator
    caffeine
    just-perfection
  ];

  # dconf settings for GNOME
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "clipboard-indicator@tudmotu.com"
        "caffeine@patapon.info"
        "just-perfection-desktop@just-perfection"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = true;
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
      binding = "<Super>t";
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
}
