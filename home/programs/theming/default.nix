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
    
    # Fonts
    nerdfonts
    jetbrains-mono
    roboto
    inter
    ubuntu_font_family
    fira-code
    hack-font
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    
    # Wallpaper tools
    swww # For Hyprland
    
    # Misc theming tools
    lxappearance
    qt5ct
  ];
  
  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.nordzy-cursor-theme;
      size = 24;
    };
    font = {
      name = "Inter";
      package = pkgs.inter;
      size = 11;
    };
  };
  
  # QT theme configuration
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "gtk2";
    };
  };
  
}
