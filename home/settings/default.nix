# home/settings/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./xdg.nix
    ./environment.nix
  ];
}
