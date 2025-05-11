{ config, lib, pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./zsh.nix
  ];
}
