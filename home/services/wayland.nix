# home/services/wayland.nix
{ pkgs, ... }:

{
  # Configure Wayland-specific services

  # Enable GTK portal for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    configPackages = [ pkgs.hyprland ];
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
  };

  # Install Wayland-specific utilities
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    wl-color-picker
    wdisplays
    waypipe
    wayshot
    wlr-randr
    slurp
    grim
    swappy # Screenshot editor
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
  ];
}
