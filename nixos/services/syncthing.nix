# nixos/services/syncthing.nix
# Syncthing file synchronization service
{
  # ============================================================================
  # Syncthing Configuration
  # ============================================================================
  services.syncthing = {
    enable = true;

    # User account to run Syncthing
    user = "boi";

    # Data directory (where synced folders are stored)
    dataDir = "/home/boi";

    # Configuration directory
    configDir = "/home/boi/.config/syncthing";

    # Automatically open firewall ports
    # Opens TCP 22000 (transfers) and UDP 21027 + 22000 (discovery)
    openDefaultPorts = true;

    # -------------------------------------------------------------------------
    # Optional: Web GUI Configuration
    # -------------------------------------------------------------------------
    # guiAddress = "127.0.0.1:8384";                    # Default Web GUI address

    # -------------------------------------------------------------------------
    # Optional: Declarative Configuration
    # -------------------------------------------------------------------------
    # Configure folders and devices declaratively (recommended for immutability)
    # settings = {
    #   devices = {
    #     "phone" = {
    #       id = "DEVICE-ID-HERE";                      # Get from Syncthing GUI
    #     };
    #     "laptop" = {
    #       id = "DEVICE-ID-HERE";
    #     };
    #   };
    #
    #   folders = {
    #     "Documents" = {
    #       path = "/home/boi/Documents";
    #       devices = [ "phone" "laptop" ];
    #       ignorePerms = false;                        # Sync permissions
    #     };
    #     "Pictures" = {
    #       path = "/home/boi/Pictures";
    #       devices = [ "phone" ];
    #       type = "receiveonly";                       # Only receive from phone
    #     };
    #   };
    #
    #   options = {
    #     urAccepted = -1;                              # Disable usage reporting
    #     globalAnnounceEnabled = true;                 # Enable discovery
    #     relaysEnabled = true;                         # Enable relay servers
    #   };
    # };
  };

  # ============================================================================
  # Additional Configuration
  # ============================================================================
  # Optional: Run Syncthing at user level (systemd user service)
  # systemd.user.services.syncthing = {
  #   wantedBy = [ "default.target" ];
  #   serviceConfig.Restart = "on-failure";
  # };
}
