# mntbnd: HP OmniBook 5 16" (Core Ultra 7 255U). The only host.
# Machine-specific bits live here; everything else comes from modules/nixos.
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
