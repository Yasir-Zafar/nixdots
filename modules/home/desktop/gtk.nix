# GTK theme is managed by nwg-look; this file is unused (did not work for this theme)
# GTK theme and icons come from the repo's assets/, not from stylix
{pkgs, ...}: let
  themeName = "Gruvbox-Green-Dark-Medium";
  iconName = "Gruvbox-Plus-Dark";
  theme = ../../assets + "/${themeName}";
  icons = ../../assets + "/${iconName}";
in {
  gtk = {
    enable = true;

    theme.name = themeName;
    iconTheme.name = iconName;

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    font = {
      name = "Inter";
      size = 11;
    };

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

  home.file = {
    ".themes/${themeName}".source = theme;
    ".icons/${iconName}".source = icons;
  };

  # libadwaita / gtk4 apps only read the theme through these files
  xdg.configFile = {
    "gtk-4.0/assets".source = "${theme}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${theme}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${theme}/gtk-4.0/gtk-dark.css";
  };
}
