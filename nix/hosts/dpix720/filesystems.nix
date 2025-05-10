{ config, pkgs, lib, ... }:

{
  fileSystems."/mnt/home/boi/Data" = {
    device = "/dev/sda1";
    fsType = "ext4";
    options = ["nofail" "noauto"];
  };
}
