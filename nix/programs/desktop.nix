# programs/desktop.nix
{ config, lib, pkgs, ... }:

{
  # Configure default applications
  environment.systemPackages = with pkgs; [
    # Media players
    mpv
    #vlc
    
    # Image viewers/editors
    imv
    #gimp
    #inkscape
    
    # Document viewers
    zathura
    #libreoffice-qt
    
    # File managers
    lf
    
    # Communication apps
    vesktop
    
    # Terminal emulators
    kitty
    
    # System utilities
    pavucontrol
    gnome-disk-utility
    
    # Screenshot and screen recording
    #obs-studio
    
    # Office and productivity
    #thunderbird
    
    # Other useful applications
    #bitwarden
    #keepassxc
    #transmission-gtk
    
    # For GTK and Qt theming
    adwaita-icon-theme
    papirus-icon-theme
    
    # Utilities
    xdg-utils
    file-roller
    
    # Bluetooth manager
    blueman
  ];
  
  # Programs with special configuration
  programs = {
    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    # Dconf for GTK applications
    dconf.enable = true;
    
    # Kdeconnect
    kdeconnect.enable = true;
    
    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  
  # Enable flatpak
  services.flatpak.enable = true;
 
  # Configure MIME types
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "inode/directory" = "pcmanfm.desktop";
      "text/plain" = "org.gnome.gedit.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
