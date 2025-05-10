# hardware/default.nix
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./graphics.nix
  ];

  # Firmware updates
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  
  # Firmware tools
  environment.systemPackages = with pkgs; [
    fwupd
    pciutils
    usbutils
    lshw
    dmidecode
    hwinfo
    inxi
  ];
  
  # Firmware update daemon
  services.fwupd.enable = true;
}
