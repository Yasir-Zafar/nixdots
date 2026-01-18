# nixos/development/nix.nix
{pkgs, ...}: {
  # System-wide language runtimes
  environment.systemPackages = with pkgs; [
    #NixOS tools
    statix
    deadnix
  ];
}
