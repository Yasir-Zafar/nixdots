# home/services/syncthing.nix
{ config, lib, pkgs, ... }:

{
  # Syncthing file synchronization
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray";
      package = pkgs.syncthingtray;
    };
  };

  # Install Syncthing-related packages
  home.packages = with pkgs; [
    syncthingtray
    syncthing-gtk
  ];
}
