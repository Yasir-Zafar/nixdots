# nixos/gaming/steam.nix
# Steam and gaming session configuration
{
  # ============================================================================
  # Steam Configuration
  # ============================================================================
  programs.steam = {
    enable = true;

    # Remote Play - stream games to other devices
    remotePlay.openFirewall = true;

    # Dedicated Server - host game servers
    dedicatedServer.openFirewall = true;

    # GameScope Session - compositing window manager for gaming
    # Provides better performance and features like FSR upscaling
    gamescopeSession.enable = true;
  };

  # ============================================================================
  # Gaming Performance Tools
  # ============================================================================
  # GameScope - micro-compositor for gaming
  programs.gamescope.enable = true;

  # GameMode - automatic performance optimizations when games are running
  programs.gamemode.enable = true;

  # ============================================================================
  # Graphics Support
  # ============================================================================
  # Enable 32-bit graphics libraries for Steam and Wine games
  hardware.graphics.enable32Bit = true;

  # Optional: Enable hardware video acceleration for 32-bit apps
  # hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
  #   intel-media-driver
  # ];
}
