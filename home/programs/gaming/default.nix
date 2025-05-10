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
  
  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  # GameMode configuration for better gaming performance
  services.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
}
