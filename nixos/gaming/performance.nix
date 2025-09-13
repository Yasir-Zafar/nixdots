{pkgs, ...}: {
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

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.file-max" = 2097152;
  };

  environment.systemPackages = with pkgs; [
    htop
    iotop
  ];

  services.irqbalance.enable = true;
}
