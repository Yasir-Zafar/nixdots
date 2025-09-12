{ config, pkgs, ... }:
{
  imports = [
    ./systemd-boot.nix
  ];
}
