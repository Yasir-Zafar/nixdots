# nixos/services/tuned.nix
# System performance tuning and power management
{
  # ============================================================================
  # Tuned - System Performance Profiles
  # ============================================================================
  # Tuned applies performance/power profiles based on usage
  services.tuned = {
    enable = true;

    # Available profiles:
    # - "balanced"                      - Balanced performance/power (default)
    # - "powersave"                     - Maximum battery life
    # - "laptop-battery-powersave"      - Laptop-optimized power saving
    # - "throughput-performance"        - Maximum performance
    # - "latency-performance"           - Low latency (gaming/audio)
    # - "desktop"                       - Desktop workstation
    # profiles = "desktop"; # Good for laptops

    settings.daemon = true;
    settings.dynamic_tuning = true;

    # Power Profiles Daemon integration
    ppdSupport = true; # Integrate with GNOME power profiles

    ppdSettings = {
      main = {
        battery_detection = true; # Detect battery status
      };
    };
  };

  # ============================================================================
  # UPower - Battery/Power Monitoring
  # ============================================================================
  # Provides battery status and power management info to desktop environment
  services.upower.enable = true;

  # ============================================================================
  # Power Profiles Daemon
  # ============================================================================
  # Disable in favor of Tuned (they conflict)
  services.power-profiles-daemon.enable = false;
}
