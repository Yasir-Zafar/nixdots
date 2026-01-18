# nixos/services/bluetooth.nix
# Bluetooth configuration with enhanced features
{pkgs, ...}: {
  # ============================================================================
  # Bluetooth Hardware Support
  # ============================================================================
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Auto-enable Bluetooth on boot

    settings = {
      General = {
        # Enable all Bluetooth profiles
        # Enable = "Source,Sink,Media,Socket";

        # Enable experimental features (better codec support)
        Experimental = true;

        # Optional: Enable dual mode (BR/EDR and LE)
        ControllerMode = "dual";

        # Optional: Set device name
        Name = "mntbnd-bt";

        # Optional: Set device class (computer)
        Class = "0x000100";

        # Auto-enable controllers
        AutoEnable = true;
      };

      # Optional: Policy settings
      Policy = {
        AutoEnable = true; # Auto-reconnect to known devices
      };
    };
  };

  # ============================================================================
  # Bluetooth Utilities
  # ============================================================================
  environment.systemPackages = with pkgs; [
    bluez # Bluetooth protocol stack
    bluez-tools # Additional Bluetooth utilities

    # Optional: Additional tools
    # blueman                                           # Blueman GUI manager
    # bluetuith                                         # TUI Bluetooth manager
  ];
}
