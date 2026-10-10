{
  imports = [
    ./hardware-configuration.nix
    ./intel-graphics.nix
    ./swap.nix
  ];

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  # the Intel TCO hardware watchdog only produces "watchdog did not stop!" at shutdown
  boot.blacklistedKernelModules = ["iTCO_wdt"];

  services.fwupd.enable = true; # vendor firmware via LVFS: fwupdmgr refresh && fwupdmgr get-updates

  services.fstrim.enable = true;
}
