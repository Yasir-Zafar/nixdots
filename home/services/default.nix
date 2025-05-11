# home/services/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./dunst.nix
    ./syncthing.nix
    ./wayland.nix
    ./batsignal.nix
  ];
}
