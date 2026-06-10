{
  imports = [
    ./hardware-configuration.nix
    ./intel-graphics.nix
  ];

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  services.fwupd.enable = false;

  services.fstrim.enable = true;
}
