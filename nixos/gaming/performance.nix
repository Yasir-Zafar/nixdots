{pkgs, ...}: {
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
  };

  services.irqbalance.enable = false;
}
