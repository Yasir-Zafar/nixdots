{
  services.syncthing = {
    enable = true;
    user = "boi"; # your username
    dataDir = "/home/boi"; # where synced folders live
    configDir = "/home/boi/.config/syncthing";
    openDefaultPorts = true; # opens 22000 + discovery ports
  };
}
