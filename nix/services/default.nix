# nixos/services/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./networking.nix
    ./printing.nix
    ./sound.nix
    ./bluetooth.nix
    ./ssh.nix
  ];
}
