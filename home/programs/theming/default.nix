{ config, lib, pkgs, ... }:

{
  # Basic theming configuration
  home.packages = with pkgs; [
    # Theme engines
    gtk-engine-murrine
    gtk_engines
    
    # Themes
    nordic
    dracula-theme
    catppuccin-gtk
    
    # Icon themes
    papirus-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    
    # Cursor themes
    bibata-cursors

    # Wallpaper tools
    swww # For Hyprland
    
    # Misc theming tools
    lxappearance
  ];
}
