_: {
  imports = [
    ./nix.nix
    ./py.nix
    ./c.nix
  ];

  virtualisation.docker.enable = true;
  users.users.boi.extraGroups = ["docker"];
}
