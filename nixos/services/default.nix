# nixos/services/default.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./networking.nix
    ./bluetooth.nix
    ./audio.nix
  ];

  # Enable location services
  services.geoclue2.enable = true;
}
