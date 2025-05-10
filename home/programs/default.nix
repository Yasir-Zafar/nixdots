{ config, lib, pkgs, ... }:

{
  imports = [
    ./terminal
    ./editors
    ./media
    ./development
    ./communication
    ./productivity
    ./gaming
    ./theming
    ./shell
    ./wayland.nix
  ];
}
