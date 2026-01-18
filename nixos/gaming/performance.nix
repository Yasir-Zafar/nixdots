# nixos/gaming/performance.nix
# System performance optimizations for gaming
{pkgs, ...}: {
  # ============================================================================
  # GameMode Configuration
  # ============================================================================
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        # Renice game processes for higher priority
        renice = 10;
      };

      gpu = {
        # Apply GPU optimizations (requires accepting responsibility)
        apply_gpu_optimisations = "accept-responsibility";

        # Optional: Set GPU performance mode
        gpu_device = 0;
        amd_performance_level = "high";
      };

      # Optional: Custom scripts to run when GameMode starts/stops
      # custom = {
      #   start = "${pkgs.systemd}/bin/systemctl --user stop backup.service";
      #   end = "${pkgs.systemd}/bin/systemctl --user start backup.service";
      # };
    };
  };

  # ============================================================================
  # Kernel Tuning for Gaming
  # ============================================================================
  boot.kernel.sysctl = {
    # Reduce swap usage - keep more in RAM for better performance
    # Default is 60, lower values mean less aggressive swapping
    "vm.swappiness" = 10;

    # Increase maximum number of open file descriptors
    # Games with many assets may need this
    "fs.file-max" = 2097152;

    # Optional: Increase inotify limits for file watching
    # Useful for game modding and development
    # "fs.inotify.max_user_watches" = 524288;
    # "fs.inotify.max_user_instances" = 512;
  };

  # ============================================================================
  # Performance Monitoring & Optimization Tools
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # System Monitoring
    htop # Interactive process viewer
    iotop # Disk I/O monitor
    btop # Resource monitor (modern htop alternative)

    # Network Monitoring
    # iftop                                             # Network bandwidth monitor
    # nethogs                                           # Per-process network usage

    # GPU Monitoring (Intel-specific tools in hardware/intel-graphics.nix)
    # nvtop                                             # GPU monitor (supports NVIDIA, AMD, Intel)
  ];

  # ============================================================================
  # System Services
  # ============================================================================
  # IRQ Balance - distribute hardware interrupts across CPU cores
  # Improves performance on multi-core systems
  services.irqbalance.enable = false;
}
