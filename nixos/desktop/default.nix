{pkgs, ...}: {
  imports = [
    ./niri.nix
    ./fonts.nix

    # kept for reference — uncomment to switch back
    # ./gnome.nix
  ];

  # greetd with regreet: a clean GTK4 Wayland greeter
  # much nicer than lightdm; runs entirely on Wayland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  # regreet is a GTK4 greeter for greetd
  # configure it via programs.regreet (home-manager) or via its config file
  programs.regreet = {
    enable = true;

    # regreet reads a TOML config; these are the available top-level keys
    settings = {
      background = {
        # path to a background image; leave unset for solid color
        # path = "/path/to/wallpaper.png";
        fit = "Cover"; # Cover | Contain | Fill | ScaleDown
      };

      GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = "Adwaita";
        font_name = "sans 12";
        icon_theme_name = "Adwaita";
        theme_name = "Adwaita";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome # keep for GTK app compatibility
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    polkit.enable = true;
    # gnome-keyring still works fine without GDM
    pam.services.greetd.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  services.flatpak.enable = true;
}
