{ pkgs, inputs, ... }:
{
  services = {
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

  environment.pathsToLink = ["share/thumbnailers"];
  programs.xwayland.enable = false;

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    dconf-editor

    inputs.zen-browser.packages."${system}".default
    inputs.nix-software-center.packages.${system}.nix-software-center
  ];

  environment.gnome.excludePackages = (with pkgs; [
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
  ]);

  programs = {
    dconf.enable = true;
  };
}
