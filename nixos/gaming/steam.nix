# nixos/gaming/steam.nix
{pkgs, ...}: {
  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
    gamescopeSession.enable = true; # GameScope session for better gaming performance
  };

  # Enable 32-bit support for Steam
  hardware.graphics.enable32Bit = true;
}
