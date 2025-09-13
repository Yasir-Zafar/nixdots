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
    geoclue2.enable = true;

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

      inputs.zen-browser.packages."${system}".default
    ];

    # Remove some default GNOME applications you might not need
    gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      cheese
      gnome-music
      epiphany
      geary
      gnome-characters
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
