# Two swap tiers. vm.swappiness stays at 10 (gaming/performance.nix) so the kernel still
# avoids swapping (modded minecraft hates being swapped out when it loses focus); when
# it does swap, it goes to compressed RAM first and only then to the SSD.
{
  # compressed swap in RAM, used first (higher priority than the swapfile)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # upper bound for the uncompressed size, not RAM taken up front
    priority = 100;
  };

  # overflow on disk
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
      priority = 10;
    }
  ];
}
