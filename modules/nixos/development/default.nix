{my, ...}: {
  imports = [
    ./nix-tools.nix
    ./py.nix
    ./c.nix
  ];

  virtualisation.docker = {
    enable = true;
    # not at boot; docker.socket starts it on first `docker` use (e.g. ARGUS `make db-up`)
    enableOnBoot = false;
    # weekly: stopped containers, dangling images, unused networks older than a week
    autoPrune = {
      enable = false; # off while docker is unused; flip back with enableOnBoot
      dates = "weekly";
      flags = ["--filter=until=168h"];
    };
  };
  users.users.${my.user}.extraGroups = ["docker"];
}
