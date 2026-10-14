{my, ...}: {
  imports = [
    ./nix.nix
    ./py.nix
    ./c.nix
  ];

  virtualisation.docker = {
    enable = true;
    # weekly: stopped containers, dangling images, unused networks older than a week
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--filter=until=168h"];
    };
  };
  users.users.${my.user}.extraGroups = ["docker"];
}
