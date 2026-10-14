{my, ...}: {
  services.syncthing = {
    enable = true;
    inherit (my) user;
    dataDir = my.home;
    configDir = "${my.home}/.config/syncthing";
    openDefaultPorts = true;
  };
}
