# nixos/development/nix.nix
{
  config,
  pkgs,
  ...
}: {
  # System-wide language runtimes
  environment.systemPackages = with pkgs; [
    #NixOS tools
    statix
    deadnix
  ];
}
