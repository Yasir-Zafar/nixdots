{
  imports = [
    ../dotfiles/default.nix
    #./scripts/default.nix
    ./desktop/default.nix
    ./terminal/default.nix
    ./development/default.nix
    ./applications/default.nix
  ];

  home = {
    username = "boi";
    homeDirectory = "/home/boi";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  # allowUnfree is set where pkgs is imported (flake.nix); setting nixpkgs.config here
  # as well would make home-manager import nixpkgs a second time
}
