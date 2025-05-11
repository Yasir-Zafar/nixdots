{ config, lib, pkgs, ... }:

{
  imports = [
    ./terminal
    ./editors
    ./media
    ./communication
    ./productivity
    ./gaming
    ./theming
    ./shell
    ./wayland.nix
    ./browser.nix
  ];
}
