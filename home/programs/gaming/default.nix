{ config, lib, pkgs, ... }:

{
  # Gaming applications and utilities
  home.packages = with pkgs; [
    # Game platforms
    steam
    lutris
    
    # Wine and compatibility layers
    wineWowPackages.stable
    winetricks
    proton-caller
    
    # Emulators
    
    # Game utilities
    gamemode
  ];
  
  # GameMode configuration for better gaming performance
}
