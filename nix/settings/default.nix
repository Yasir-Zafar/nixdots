# settings/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./locale.nix
    ./nix.nix
    ./security.nix
    ./fonts.nix
  ];
}
