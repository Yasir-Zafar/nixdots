{
  imports = [
    ./nix.nix
    ./hardware
    ./boot
    ./desktop
    ./gaming
    ./development
    ./users
    ./security
    ./services
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
