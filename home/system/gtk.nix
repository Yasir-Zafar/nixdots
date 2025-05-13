# home/system/gtk.nix
{ pkgs, ... }:

{
  # GTK configuration
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita";
    };

    iconTheme = {
      name = "Adwaita";
    };

    font = {
      name = "Inter";
      size = 11;
    };

    # Ensure settings apply across GTK3 and GTK4
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Install GTK theme engines and related packages
  xdg.enable = true;

  home.packages = with pkgs; [
    gsettings-desktop-schemas
    gnome-themes-extra
  ];
}
