{
  pkgs,
  inputs,
  ...
}: {
  services = {
    gnome = {
      gnome-keyring.enable = true;
      localsearch.enable = true;
      gnome-online-accounts.enable = true;
      sushi.enable = true;
      at-spi2-core.enable = true;
      tinysparql.enable = true;
    };

    desktopManager.gnome.enable = true;

    udev.packages = [pkgs.gnome-settings-daemon];

    gvfs.enable = true;
  };

  programs.xwayland.enable = true;
  programs.dconf.enable = true;

  environment = {
    pathsToLink = ["share/thumbnailers"];

    systemPackages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
      dconf-editor

      gnome-calendar
      gnome-calculator
      gnome-usage
      gnome-disk-utility
      gnome-pomodoro
      file-roller

      gnome-autoar
      refine
      nwg-look

      sassc
      gtk-engine-murrine
      gnome-themes-extra

      libheif
      libheif.out

      bitwarden-desktop
      inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    ];

    gnome.excludePackages = with pkgs; [
      yelp
      gnome-user-docs
      gnome-tour

      epiphany
      geary
      evince
      totem
      cheese
      simple-scan
      gnome-music
      gnome-photos

      gnome-maps
      gnome-weather
      gnome-calendar
      gnome-clocks
      gnome-characters
      gnome-logs
      gnome-font-viewer
      gnome-calculator

      gnome-connections
      gnome-console
      gnome-initial-setup
      gnome-software
      seahorse

      tali
      iagno
      hitori
      atomix
    ];
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=
    DOWNLOAD=Downloads
    TEMPLATES=
    PUBLICSHARE=
    DOCUMENTS=Documents
    MUSIC=Music
    PICTURES=Pictures
    VIDEOS=Videos
  '';
}
