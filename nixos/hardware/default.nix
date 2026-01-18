# nixos/hardware/default.nix
# Hardware configuration and drivers
{
  imports = [
    ./hardware-configuration.nix # Generated hardware config
    ./intel-graphics.nix # Intel GPU drivers
  ];

  # ============================================================================
  # Firmware Configuration
  # ============================================================================
  hardware = {
    # Enable non-free firmware (WiFi, Bluetooth, etc.)
    enableRedistributableFirmware = true;
    enableAllFirmware = true;

    # CPU microcode updates for security and stability
    cpu.intel.updateMicrocode = true;
  };

  # ============================================================================
  # System Services
  # ============================================================================
  # Firmware update service (LVFS/fwupd)
  # Allows updating firmware via GNOME Software or `fwupdmgr`
  services.fwupd.enable = true;

  # SSD TRIM support - improves SSD performance and longevity
  # Runs weekly by default
  services.fstrim = {
    enable = true;
    # interval = "weekly";                              # Default schedule
  };

  # ============================================================================
  # Additional Hardware Support (Optional)
  # ============================================================================
  # Uncomment based on your hardware needs:

  # Bluetooth
  # hardware.bluetooth = {
  #   enable = true;
  #   powerOnBoot = true;                               # Auto-enable on boot
  # };
  # services.blueman.enable = true;                     # Bluetooth manager GUI

  # Audio
  # hardware.pulseaudio.enable = false;                 # Use PipeWire instead
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   jack.enable = true;                               # For professional audio
  # };

  # Laptop-specific
  # services.thermald.enable = true;                    # Intel thermal daemon
  # services.tlp.enable = true;                         # Power management
  # powerManagement.enable = true;
}
