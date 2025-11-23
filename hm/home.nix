# hm/home.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../dotfiles/default.nix
    ./scripts/default.nix
    ./desktop/default.nix
    ./development/default.nix
    ./applications/default.nix
  ];

  home = {
    username = "boi";
    homeDirectory = "/home/boi";

    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
}
