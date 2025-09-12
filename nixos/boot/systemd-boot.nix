
{ config, pkgs, ... }:
{
  boot.oader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernalParams = [
    "quiet"
    "splash"
  ];

  boot.kernalPackages = pkgs.linuxPackages_latest;

  boot.supportedFilesystems = [ "ntfs" ];
}
