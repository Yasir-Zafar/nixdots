# home/system/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./cursor.nix
  ];
}
