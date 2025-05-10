# home/system/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./cursor.nix
  ];
}
