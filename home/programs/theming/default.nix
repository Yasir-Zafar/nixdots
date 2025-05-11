{ config, lib, pkgs, ... }:

{
  # Basic theming configuration
  home.packages = with pkgs; [
    # Theme engines
    gtk-engine-murrine
    gtk_engines
    
    # Icon themes
    papirus-icon-theme
    
    # Cursor themes
    bibata-cursors

    # Wallpaper tools
    swww # For Hyprland

    nwg-look
  ];
}
