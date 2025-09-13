# hm/desktop/gtk.nix
{
  config,
  pkgs,
  ...
}: {
  # GTK configuration
  gtk = {
    enable = true;

    # theme = {
    #   name = "Adwaita-dark";
    #   package = pkgs.gnome-themes-extra;
    # };
    #
    # iconTheme = {
    #   name = "Adwaita";
    #   package = pkgs.adwaita-icon-theme;
    # };
    #
    cursorTheme = {
      name = "Biabata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };

    font = {
      name = "Inter";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Dark theme for applications
  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
  };
}
