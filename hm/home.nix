{ config, pkgs, ... }:
{
  imports = [
    ../dotfiles
  ];
  home.username = "boi";
  home.homeDirectory = "/home/boi";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
}
