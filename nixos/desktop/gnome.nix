{ pkgs, ... }:
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

    udev.packages = [pkgs.gnome-settings-deamon];
    sysprof.enable = true;
    gvfs.enable = true;
  };

  enviroment.pathsToLink = ["share/thumbnailers"];
  programs.xwayland.enable = false;

  enviroment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    dconf-editor
  ];

  enviroment.gnome.excludePackages = (with pkgs; [
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
  )];

  programs = {
    dconf.enable = true;
  };
}
