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

  services.fwupd.enable = false;

  services.fstrim.enable = true;
}
