# home/system/gtk.nix
{ config, lib, pkgs, ... }:

{
  # GTK configuration
  gtk = {
    enable = true;
    
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    font = {
      name = "Inter";
      size = 11;
    };
    
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-button-images = true;
        gtk-menu-images = true;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-name = "Bibata-Modern-Ice";
        gtk-cursor-theme-size = 24;
      };
    };
    
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-name = "Bibata-Modern-Ice";
        gtk-cursor-theme-size = 24;
      };
    };
  };

  # Install GTK theme engines and related packages
  home.packages = with pkgs; [
    adwaita-icon-theme
    adwaita-qt
    adwaita-qt6
    qt6ct
    libsForQt5.qtstyleplugin-kvantum
    lxappearance
    xfce.thunar
    dconf
    gsettings-desktop-schemas
    gnome-themes-extra
  ];

  # Set some GNOME/GTK settings using dconf
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = true;
      font-antialiasing = "rgba";
      font-hinting = "slight";
      document-font-name = "Inter 11";
      font-name = "Inter 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
    };
    
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font = "Inter Bold 11";
    };
  };
}
