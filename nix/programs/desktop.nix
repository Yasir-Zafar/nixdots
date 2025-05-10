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
    alacritty
    kitty
    foot
    
    # Development tools
    vscode
    helix
    
    # System utilities
    pavucontrol
    gnome.gnome-disk-utility
    
    # Screenshot and screen recording
    #obs-studio
    
    # Office and productivity
    #thunderbird
    
    # Other useful applications
    #bitwarden
    #keepassxc
    #transmission-gtk
    
    # For GTK and Qt theming
    gnome.adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
    breeze-icons
    breeze-gtk
    breeze-qt5
    
    # Utilities
    xdg-utils
    libsForQt5.ark
    gnome.file-roller
    
    # Bluetooth manager
    blueman
    
    # Screensaver
    xscreensaver
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
    
    # Kitty terminal emulator
    kitty.enable = true;
    
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
  
  # Configure GTK themes
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Breeze-Dark
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=Inter 11
    gtk-cursor-theme-name=Breeze_Snow
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark-theme=true
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintslight
    gtk-xft-rgba=rgb
    gtk-enable-animations=true
  '';
  
  # Configure environment variables for Qt applications to use GTK themes
  environment.variables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_THEME = "Breeze-Dark";
  };
  
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
