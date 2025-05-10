# programs/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./shells.nix
    ./desktop.nix
  ];
}
