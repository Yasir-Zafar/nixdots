# zram first, then the swapfile; swappiness 10 (modded minecraft hates being swapped out)
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
