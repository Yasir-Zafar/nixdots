{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["nvme_core.default_ps_max_latency_us=0"];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };

      efi.canTouchEfiVariables = true;

      timeout = 3;
    };
  };
}
