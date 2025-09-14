# nixos/hardware/default.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./intel-graphics.nix
  ];

  hardware = {
    # Firmware updates
    enableRedistributableFirmware = true;
    enableAllFirmware = true;

    # CPU microcode updates
    cpu.intel.updateMicrocode = true;
  };

  # Firmware update daemon
  services.fwupd.enable = true;

  # SSD optimization
  services.fstrim.enable = true;
}
