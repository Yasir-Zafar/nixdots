{ pkgs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./graphics.nix
  ];

  # Firmware updates
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  # CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # SSD optimization
  services.fstrim.enable = true;

  # Firmware tools
  environment.systemPackages = with pkgs; [
    fwupd
    pciutils
    usbutils
    lshw
    dmidecode
    hwinfo
    inxi
    smartmontools
  ];

  # Firmware update daemon
  services.fwupd.enable = true;
}
