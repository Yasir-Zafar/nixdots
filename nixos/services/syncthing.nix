{
  services.syncthing = {
    enable = true;
    user = "boi";
    dataDir = "/home/boi";
    configDir = "/home/boi/.config/syncthing";
    openDefaultPorts = true;
  };
}
