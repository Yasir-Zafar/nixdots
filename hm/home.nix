# hm/home.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../dotfiles
    ./desktop
  ];

  home = {
    username = "boi";
    homeDirectory = "/home/boi";

    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
}
