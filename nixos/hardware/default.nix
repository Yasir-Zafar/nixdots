{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./intel-graphics.nix
  ];

  services.fwupd.enable = true;

}
