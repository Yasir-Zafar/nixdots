{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Green-Dark-Medium";
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
    };

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
}
