# nixos/desktop/gnome.nix
{
  pkgs,
  inputs,
  ...
}: {
  services = {
    # GNOME services
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

  programs.xwayland.enable = false;

  environment = {
    pathsToLink = ["share/thumbnailers"];

    # Essential GNOME packages
    systemPackages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
      dconf-editor
      gnome-calendar
      gnome-calculator
      gnome-usage
      gnome-disk-utility
      gnome-pomodoro
      gnome-autoar
      file-roller
      refine

      # Password management
      bitwarden
      libheif
      libheif.out

      inputs.zen-browser.packages."${system}".default
    ];

    # Remove some default GNOME applications you might not need
    gnome.excludePackages = with pkgs; [
      yelp
      gnome-user-docs
      simple-scan
      seahorse
      gnome-tour
      gnome-connections
      gnome-console
      gnome-music
      gnome-photos
      gnome-maps
      gnome-weather
      gnome-calendar
      gnome-clocks
      gnome-initial-setup
      gnome-software
      gnome-characters
      gnome-logs
      gnome-font-viewer
      gnome-calculator
      epiphany
      geary
      evince
      totem
      cheese
      tali
      iagno
      hitori
      atomix
    ];
  };

  programs = {
    dconf.enable = true;
  };

  # Prevent creation of default XDG user directories
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
