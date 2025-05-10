# userspace/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./development.nix
  ];
}
