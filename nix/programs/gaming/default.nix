{ pkgs, ... }:
{
  imports = [
    #./retroarch.nix
  ];
  # Gaming applications and utilities
  environment.systemPackages = with pkgs; [
    # Game platforms
    steam
    lutris

    # Wine and compatibility layers
    wineWowPackages.stable
    winetricks
    proton-caller

    # Game utilities
    gamemode
  ];

  # GameMode configuration for better gaming performance
}
