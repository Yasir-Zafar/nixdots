# home/services/syncthing.nix
{ pkgs, ... }:

{
  # Syncthing file synchronization
  services.syncthing = {
    enable = true;
    tray = {
      enable = false;
      command = "syncthingtray";
      package = pkgs.syncthingtray;
    };
  };

  # Install Syncthing-related packages
  home.packages = with pkgs; [
    syncthingtray
  ];
}
