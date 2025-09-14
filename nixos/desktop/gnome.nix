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
    };

    desktopManager.gnome.enable = true;

    udev.packages = [pkgs.gnome-settings-daemon];
    sysprof.enable = true;
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
      gnome-tour
      gnome-connections
      gnome-console
      gnome-music
      gnome-photos
      gnome-maps
      gnome-weather
      gnome-contacts
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
}
