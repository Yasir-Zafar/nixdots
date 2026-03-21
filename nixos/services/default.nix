{pkgs, ...}: {
  imports = [
    ./networking.nix
    ./bluetooth.nix
    ./audio.nix
    ./enviroment.nix
    ./power.nix
    ./syncthing.nix
  ];

  services = {
    geoclue2.enable = true;
  };
}
