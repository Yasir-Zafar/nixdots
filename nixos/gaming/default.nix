# nixos/gaming/default.nix
{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./performance.nix
    ./retroarch.nix
  ];

  environment.systemPackages = with pkgs; [
    gamemode
    mangohud

    bottles
  ];
}
