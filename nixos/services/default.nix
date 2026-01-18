# nixos/services/default.nix
# System services configuration aggregator
{pkgs, ...}: {
  imports = [
    ./networking.nix # Network and DNS configuration
    ./bluetooth.nix # Bluetooth support
    ./audio.nix # PipeWire audio system
    ./enviroment.nix # Environment variables
    ./power.nix # Performance/power profiles
    ./syncthing.nix # File synchronization
  ];

  services = {
    # ============================================================================
    # Additional System Services
    # ============================================================================

    # Location services (required by GNOME, used for weather, time zones, etc.)
    geoclue2.enable = true;

    # ============================================================================
    # Optional Services
    # ============================================================================
    # Uncomment as needed:

    # Printing support
    printing = {
      enable = true;
      drivers = [pkgs.gutenprint]; # Additional printer drivers
    };
    avahi = {
      # Printer discovery
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  # Scanning support
  # hardware.sane.enable = true;                        # Scanner drivers
  # users.users.boi.extraGroups = [ "scanner" "lp" ];

  # Smart card support
  # services.pcscd.enable = true;

  # Automatic system upgrades (use with caution!)
  # system.autoUpgrade = {
  #   enable = false;
  #   allowReboot = false;
  #   dates = "weekly";
  # };
}
