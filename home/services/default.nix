# home/services/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./mako.nix
    ./syncthing.nix
    ./wayland.nix
    ./batsignal.nix
  ];
}
