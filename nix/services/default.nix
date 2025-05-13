# nixos/services/default.nix
{
  imports = [
    ./networking.nix
    ./sound.nix
    ./bluetooth.nix
    ./ssh.nix
  ];

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
