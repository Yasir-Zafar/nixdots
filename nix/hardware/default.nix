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

  services.fwupd.enable = true; # vendor firmware via LVFS: fwupdmgr refresh && fwupdmgr get-updates

  services.fstrim.enable = true;
}
