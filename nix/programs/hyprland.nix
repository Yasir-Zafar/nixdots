# programs/hyprland.nix
{ config, lib, pkgs, inputs, ... }:

{
  # Enable Hyprland window manager at the system level
  programs.hyprland = {
    enable = true;
    #xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Required system packages for Hyprland to work properly
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    wayland
    wayland-utils
    wayland-protocols
    wayland-scanner
    wl-clipboard
    wlr-randr
    wev
    
    # XDG utilities
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-utils
    
    # Notification daemon
    libnotify
    
    # Screenshot utilities
    grim
    slurp
    swappy
    
    # For waybar and other GTK apps
    gtk3
    gsettings-desktop-schemas
    
    # Polkit authentication agent
    polkit_gnome

    hyprpanel
  ];
  
  # Configure XDG portals for proper desktop integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
  
  # Configure some services needed for Hyprland
  services = {
    # For gtk applications
    dbus.packages = [ pkgs.dconf ];
    
    # Gnome virtual file system
    gvfs.enable = true;
    
    # Thumbnail service
    tumbler.enable = true;
  };
  
  # Enable some essential programs
  programs = {
    # For file browser and thumbnails
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  
  # Environment variables for Wayland/Hyprland
  environment.sessionVariables = {
    # For Hyprland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland";
  };
  
  # Security policy for Hyprland
  security = {
    # Allow swaylock to unlock the screen
    # pam.services.swaylock = {};
    
    # Allow screen idle management
    # pam.services.swayidle = {};
  };
}
