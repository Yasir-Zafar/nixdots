# nixos/boot/systemd-boot.nix
# Boot configuration with systemd-boot and performance optimizations
{pkgs, ...}: {
  boot = {
    # ============================================================================
    # Boot Loader Configuration
    # ============================================================================
    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        # Limit generations to prevent boot partition from filling up
        configurationLimit = 10;
        # Disable editor for security (prevents boot parameter modification)
        editor = false;
      };

      # Quick boot timeout (1 second)
      timeout = 1;
    };

    # ============================================================================
    # Kernel Configuration
    # ============================================================================
    # Use latest kernel for better hardware support and security updates
    kernelPackages = pkgs.linuxPackages_latest;

    # Performance and compatibility kernel parameters
    kernelParams = [
      # Boot appearance
      "splash"
      "quiet"
      "loglevel=3" # Reduce boot message verbosity

      # Security & Performance
      "mitigations=auto" # Auto-enable CPU vulnerability mitigations

      # Intel-specific
      "intel_iommu=on" # Enable Intel IOMMU for virtualization
      "kvm-intel.nested=1" # Enable nested virtualization (optional)

      # Hardware fixes
      "acpi_osi=Linux" # FIXED: Better ACPI compatibility
      "acpi_backlight=native" # Fix backlight control on laptops
      "pci=noaer" # Disable PCIe Advanced Error Reporting (reduces log spam)
      "snd-intel-dspcfg.dsp_driver=1" # Intel audio DSP configuration
      "i8042.nopnp" # Fix keyboard/mouse detection issues

      # NVMe power management
      "nvme_core.default_ps_max_latency_us=5500" # Optimize NVMe power states
    ];

    # ============================================================================
    # Initial RAM Disk Modules
    # ============================================================================
    initrd.kernelModules = [
      "nvme" # NVMe drive support
      "xhci_pci" # USB 3.0 support
      "ahci" # SATA support
    ];

    # Runtime kernel modules
    kernelModules = [
      "kvm-intel" # Intel virtualization support
      "coretemp" # CPU temperature monitoring
    ];

    # ============================================================================
    # File System Configuration
    # ============================================================================
    # Enable NTFS support (useful for dual-boot Windows systems)
    supportedFilesystems = ["ntfs"];

    # Clean /tmp on boot for security and disk space
    tmp.cleanOnBoot = true;
  };

  # Disable core dumps to reduce log spam from Electron crashes
  systemd.coredump.enable = true;

  # ============================================================================
  # File System Optimizations
  # ============================================================================
  fileSystems."/" = {
    options = [
      "noatime" # Don't update access times (performance boost)
      "commit=60" # Commit changes every 60 seconds (vs default 5)
    ];
  };

  # Add to boot configuration for SSD optimization
  services.fstrim.enable = true;

  # Add to desktop for better performance
  services.earlyoom.enable = true; # Prevents system freeze on low memory
}
