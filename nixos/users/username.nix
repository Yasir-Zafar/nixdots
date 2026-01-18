# nixos/users/boi.nix
# User-specific system configuration for user 'boi'
{pkgs, ...}: {
  # ============================================================================
  # Localization Settings
  # ============================================================================
  # System language and formatting
  i18n.defaultLocale = "en_GB.UTF-8";

  # Additional locale settings (optional)
  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "en_GB.UTF-8";
  #   LC_IDENTIFICATION = "en_GB.UTF-8";
  #   LC_MEASUREMENT = "en_GB.UTF-8";
  #   LC_MONETARY = "en_GB.UTF-8";
  #   LC_NAME = "en_GB.UTF-8";
  #   LC_NUMERIC = "en_GB.UTF-8";
  #   LC_PAPER = "en_GB.UTF-8";
  #   LC_TELEPHONE = "en_GB.UTF-8";
  #   LC_TIME = "en_GB.UTF-8";
  # };

  # ============================================================================
  # Time Zone
  # ============================================================================
  time.timeZone = "Asia/Karachi";

  # Optional: Enable automatic timezone detection
  # services.localtimed.enable = true;                  # Auto-detect timezone from location
  # services.automatic-timezoned.enable = true;         # Alternative auto-detection

  # ============================================================================
  # Console Configuration
  # ============================================================================
  console = {
    keyMap = "us"; # Console keyboard layout

    # Optional: Console font
    # font = "Lat2-Terminus16";

    # Optional: Early console settings
    # earlySetup = true;
  };

  # ============================================================================
  # User-Specific System Packages
  # ============================================================================
  # Note: Most packages should be managed via Home Manager
  # Only add system-level packages that require root privileges here
  users.users.boi.packages = with pkgs; [
    # Example: System tools that need special permissions
    # Add user-specific system packages here if needed
    # Most applications should go in Home Manager configuration
  ];

  # ============================================================================
  # User-Specific System Services
  # ============================================================================
  # Example: User-specific systemd services
  # systemd.user.services.example = {
  #   description = "Example user service";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.example}/bin/example";
  #     Restart = "on-failure";
  #   };
  # };
}
