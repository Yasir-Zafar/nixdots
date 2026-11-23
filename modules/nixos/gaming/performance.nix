_: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      # no [gpu] section: gamemode's gpu tweaks are nvidia/amd only (this is an intel igpu)
    };
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.file-max" = 2097152;

    # SteamOS values: no split-lock penalty (~10ms each)
    "kernel.split_lock_mitigate" = 0;
    # finer CPU-bandwidth slices: smoother frame pacing under load
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    # free closed connections sooner (game servers, launchers)
    "net.ipv4.tcp_fin_timeout" = 5;
  };

  # ntsync: faster than wine/proton's esync/fsync emulation
  boot.kernelModules = ["ntsync"];

  services.irqbalance.enable = false;
}
