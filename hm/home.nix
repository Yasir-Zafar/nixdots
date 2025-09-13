# hm/home.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../dotfiles
    ./scripts
    ./desktop
    ./development
    ./applications
  ];

  home = {
    username = "boi";
    homeDirectory = "/home/boi";

    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
}
