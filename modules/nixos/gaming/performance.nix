_: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };

      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.file-max" = 2097152;

    # SteamOS values (same set nix-gaming's platformOptimizations applies):
    # don't deliberately slow down games that trigger split locks (the default
    # mitigation adds a ~10ms penalty per occurrence)
    "kernel.split_lock_mitigate" = 0;
    # finer CPU-bandwidth slices: smoother frame pacing under load
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    # free closed connections sooner (game servers, launchers)
    "net.ipv4.tcp_fin_timeout" = 5;
    # vm.max_map_count: nixos already sets it high enough (1048576)
  };

  # NT synchronisation primitives in the kernel: wine 10+ / proton use /dev/ntsync
  # when it exists, which is faster than their userspace emulation (esync/fsync)
  boot.kernelModules = ["ntsync"];

  services.irqbalance.enable = false;
}
