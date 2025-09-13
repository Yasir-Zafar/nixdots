# nixos/gaming/performance.nix
{pkgs, ...}: {
  # GameMode configuration
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
      };
    };
  };

  # Gaming optimizations
  boot.kernel.sysctl = {
    # Reduce swappiness for better gaming performance
    "vm.swappiness" = 10;
    # Increase file descriptor limits
    "fs.file-max" = 2097152;
  };

  # Additional gaming tools
  environment.systemPackages = with pkgs; [
    # Performance monitoring
    htop
    iotop

    # System optimization
    irqbalance
  ];

  # Enable irqbalance for better interrupt handling
  services.irqbalance.enable = true;
}
