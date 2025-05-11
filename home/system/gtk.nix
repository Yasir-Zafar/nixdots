# home/system/gtk.nix
{ config, lib, pkgs, ... }:

{
  # GTK configuration
  gtk = {
    enable = true;
    
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    font = {
      name = "Inter";
      size = 11;
    };

  };

  # Install GTK theme engines and related packages
  home.packages = with pkgs; [
    gsettings-desktop-schemas
    gnome-themes-extra
  ];
}
